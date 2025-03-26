class SoilEvaluationRequest < ApplicationRecord
  include CmAdmin::SoilEvaluationRequest

  has_one_attached :result_pdf
  has_one_attached :spanish_result_pdf

  has_one :inorganic_recommendation, dependent: :destroy
  has_one :organic_recommendation, dependent: :destroy
  has_one :soil_evaluation_result, dependent: :destroy

  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :crop, class_name: 'Constant'
  belongs_to :state, class_name: 'Constant', optional: true
  belongs_to :desired_productivity, class_name: 'Constant'
  belongs_to :organic_matter, class_name: 'Constant'
  belongs_to :gender, class_name: 'Constant', optional: true
  belongs_to :age_range, class_name: 'Constant', optional: true

  delegate :name, to: :crop, prefix: true, allow_nil: true
  delegate :name, to: :state, prefix: true, allow_nil: true
  delegate :name, to: :desired_productivity, prefix: true, allow_nil: true
  delegate :name, to: :organic_matter, prefix: true, allow_nil: true
  delegate :name, to: :gender, prefix: true, allow_nil: true
  delegate :name, to: :age_range, prefix: true, allow_nil: true
  delegate :url, to: :result_pdf, prefix: true, allow_nil: true
  delegate :url, to: :spanish_result_pdf, prefix: true, allow_nil: true

  after_commit :calculate_result

  before_validation :set_creator, on: :create

  def desired_productivity_amount
    ::CropProduction.find_by(crop:, desired_productivity:).productivity
  end

  def inorganic_recommendation_url
    "#{Rails.application.credentials[:be_url]}/cm_admin/inorganic_recommendations/#{inorganic_recommendation.id}"
  end

  def organic_recommendation_url
    return nil if organic_recommendation.blank?

    "#{Rails.application.credentials[:be_url]}/cm_admin/organic_recommendations/#{organic_recommendation&.id}"
  end

  def soil_evaluation_result_url
    "#{Rails.application.credentials[:be_url]}/cm_admin/soil_evaluation_results/#{soil_evaluation_result.id}"
  end

  def calculate_result
    ::InorganicRecommendation.find_or_create_by(soil_evaluation_request: self).calculate
    if inorganic_recommendation.apply_organic_matter?
      ::OrganicRecommendation.find_or_create_by(soil_evaluation_request: self).calculate
    else
      organic_recommendation&.destroy
    end
    ::SoilEvaluationResult.find_or_create_by(soil_evaluation_request: self).calculate
  end

  def generate_result_pdf
    url = "#{Rails.application.credentials[:be_url]}/pdfs/#{id}/result_pdf"
    grover = Grover.new(url,
                        extra_http_headers: { 'Authorization': Rails.application.credentials[:pdfs_generate_token] })
    pdf = grover.to_pdf
    result_pdf.attach(io: StringIO.new(pdf), filename: "#{parcel_name}.pdf")
  end

  def generate_spanish_result_pdf
    url = "#{Rails.application.credentials[:be_url]}/pdfs/#{id}/result_pdf_spanish"
    grover = Grover.new(url,
                        extra_http_headers: { 'Authorization': Rails.application.credentials[:pdfs_generate_token] })
    pdf = grover.to_pdf
    spanish_result_pdf.attach(io: StringIO.new(pdf), filename: "#{parcel_name}_es.pdf")
  end

  private

  def set_creator
    self.creator = Current.user
  end
end
