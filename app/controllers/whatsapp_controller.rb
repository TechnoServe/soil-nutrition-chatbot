class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token
  include WhatsappFlowEncryption

  def flow
    decrypted_data, aes_key, iv = decrypt_request(params[:encrypted_flow_data], params[:encrypted_aes_key], params[:initial_vector])
    response = if decrypted_data['action'] == 'ping'
                 { data: { status: "active" } }
               else
                 {}
               end
    encrypted_data = encrypt_response(response, aes_key, iv)
    render plain: encrypted_data
  end

  def get_webhook
    challenge = params['hub.challenge']
    render plain: challenge, status: 200
  end

  def post_webhook
    phone_number_id = Rails.application.credentials.dig(:meta, :phone_number_id)
    access_token = Rails.application.credentials.dig(:meta, :access_token)
    user_message = params.dig(:whatsapp, :entry, 0, :changes, 0, :value, :messages, 0, :text, :body)
    reply_message = params.dig(:whatsapp, :entry, 0, :changes, 0, :value, :messages, 0, :interactive, :button_reply, :id)
    form_filled_data = JSON.parse(params.dig(:entry, 0, :changes, 0, :value, :messages, 0, :interactive, :nfm_reply,
                                             :response_json) || '{}').with_indifferent_access
    user_mobile_number = params.dig(:entry, 0, :changes, 0, :value, :contacts, 0, :wa_id)

    api_service = WhatsappApiService.new(access_token)
    if user_message.present?
      api_service.send_choose_language_message(phone_number_id, user_mobile_number)
    elsif reply_message.present?
      if reply_message == 'espanol'
        language = :es
        flow_id = Rails.application.credentials.dig(:meta, :spanish_flow_id)
      elsif reply_message == 'english'
        language = :en
        flow_id = Rails.application.credentials.dig(:meta, :english_flow_id)
      end
      api_service.send_flow_message(phone_number_id, user_mobile_number, flow_id, language)
    elsif form_filled_data.present?
      language = form_filled_data['language'].to_sym
      api_service.send_preparing_result_message(phone_number_id, user_mobile_number, language)
      data = soil_evaluation_request_params(form_filled_data)
      soil_evaluation_request = SoilEvaluationRequest.create!(data)
      soil_evaluation_request.calculate_result
      GenerateResultPdfJob.perform_later(soil_evaluation_request, send_to_whatsapp: true, language:, to: user_mobile_number)
    end
    render plain: 'ok', status: :ok
  end

  private

  def soil_evaluation_request_params(data)
    data.delete(:flow_token)
    language = data.delete(:language).to_sym || :en
    crop_name = data.delete(:crop).titleize
    desired_productivity_name = data.delete(:desired_productivity).titleize
    state_name = data.delete(:region_name)&.titleize
    organic_matter_name = data.delete(:organic_matter_name)&.titleize
    gender_name = data.delete(:gender)&.titleize
    age_range_name = data.delete(:age_range)&.titleize

    if language == :es
      data[:fertigation] = data[:fertigation] == 'Si'
      state = Constant.state.joins(:constant_translations).where(constant_translations: { name: state_name }).first
      crop = Constant.crop.joins(:constant_translations).where(constant_translations: { name: crop_name }).first
      desired_productivity = Constant.desired_productivity.joins(:constant_translations)
                                     .where(constant_translations: { name: desired_productivity_name }).first
      organic_matter = Constant.organic_matter.joins(:constant_translations)
                               .where(constant_translations: { name: organic_matter_name }).first
      gender = Constant.gender.joins(:constant_translations).where(constant_translations: { name: gender_name }).first
      age_range = Constant.age_range.joins(:constant_translations)
                          .where(constant_translations: { name: age_range_name }).first
    else
      state = Constant.state.find_by(name: state_name)
      crop = Constant.crop.find_by(name: crop_name)
      desired_productivity = Constant.desired_productivity.find_by(name: desired_productivity_name)
      organic_matter = Constant.organic_matter.find_by(name: organic_matter_name)
      gender = Constant.gender.find_by(name: gender_name)
      age_range = Constant.age_range.find_by(name: age_range_name)
    end

    data.merge(state_id: state&.id, crop_id: crop.id, desired_productivity_id: desired_productivity.id,
               organic_matter_id: organic_matter&.id, gender_id: gender&.id, age_range_id: age_range&.id)
  end
end
