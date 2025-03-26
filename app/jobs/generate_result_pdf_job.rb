class GenerateResultPdfJob < ApplicationJob
  queue_as :default

  def perform(soil_evaluation_request, send_to_whatsapp: false, language: :en, to: nil)
    soil_evaluation_request.generate_result_pdf
    soil_evaluation_request.generate_spanish_result_pdf

    return unless send_to_whatsapp

    phone_number_id = Rails.application.credentials.dig(:meta, :phone_number_id)
    access_token = Rails.application.credentials.dig(:meta, :access_token)

    api_service = WhatsappApiService.new(access_token)
    if language == :en
      caption = "Here's your report; please let us know if you have any questions by sending an email to yperez@tns.org."
      api_service.send_result_pdf_message(phone_number_id, to, soil_evaluation_request.result_pdf.url,
                                          soil_evaluation_request.result_pdf.filename.to_s, caption)
    elsif language == :es
      caption = 'Aquí está su informe; por favor háganos saber si tiene alguna pregunta enviando un correo electrónico a yperez@tns.org.'
      api_service.send_result_pdf_message(phone_number_id, to, soil_evaluation_request.spanish_result_pdf.url,
                                          soil_evaluation_request.spanish_result_pdf.filename.to_s, caption)
    end
    sleep(5) # Wait for the PDF to be sent before sending the end message
    api_service.send_end_message(phone_number_id, to, language)
  end
end
