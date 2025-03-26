class OrganicRecommendation < ApplicationRecord
  include CmAdmin::OrganicRecommendation

  belongs_to :soil_evaluation_request

  delegate :parcel_name, :producer_name, :organic_matter_name, to: :soil_evaluation_request, allow_nil: true, prefix: true

  def calculate
    mo_level = soil_evaluation_request.organic_matter_value.to_f
    mo_increase = 2
    usable_area = 50
    van_bemmelen_factor = 1.724
    mo_level_required = mo_increase - mo_level
    carbon_content = soil_evaluation_request.organic_matter.carbon_content.to_f
    result = ((((mo_level_required / van_bemmelen_factor) * 1) * soil_evaluation_request.sampling_depth.to_f * soil_evaluation_request.apparent_density.to_f * 0.1) / carbon_content) * 100
    useful_area_result = [((result * usable_area) / 100).round(2), 0].max
    update!(amount: useful_area_result * 1000)
  end
end
