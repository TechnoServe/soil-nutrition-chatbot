class InorganicRecommendation < ApplicationRecord
  include CmAdmin::InorganicRecommendation

  belongs_to :soil_evaluation_request
  has_many :inorganic_recommendation_rows, dependent: :destroy

  delegate :producer_name, :parcel_name, :crop_name, to: :soil_evaluation_request, prefix: true, allow_nil: true

  def calculate
    ActiveRecord::Base.transaction do
      inorganic_recommendation_rows.destroy_all
      ::Constant.amendment.each do |amendment|
        inorganic_recommendation_row = inorganic_recommendation_rows.create!(amendment:)
        inorganic_recommendation_row.calculate
      end
    rescue StandardError => e
      Airbrake.notify_sync(e)
      raise e
    end
  end

  def apply_organic_matter?
    amendment_names = ['Organic matter', 'First year agricultural gypsum and second year organic matter']
    organic_matter_amendments = ::Constant.amendment.where(name: amendment_names)
    inorganic_recommendation_rows.where(amendment: organic_matter_amendments).pluck(:result).any?
  end
end
