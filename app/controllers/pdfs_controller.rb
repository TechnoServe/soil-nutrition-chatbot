class PdfsController < ApplicationController
  # before_action :authenticate_token

  def result_pdf
    @soil_evaluation_request = SoilEvaluationRequest.find(params[:pdf_id])
    render 'pdfs/result_pdf'
  end

  def result_pdf_spanish
    I18n.locale = :es
    @soil_evaluation_request = SoilEvaluationRequest.find(params[:pdf_id])
    render 'pdfs/result_pdf_spanish'
  end

  private

  def authenticate_token
    token = request.headers['Authorization']
    return if token == Rails.application.credentials[:pdfs_generate_token]

    render html: 'Unauthorized', status: :unauthorized
  end
end
