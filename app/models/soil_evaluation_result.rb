class SoilEvaluationResult < ApplicationRecord
  RESULTS_TYPE = %i[supply_of_nutrient crop_demand fertilization_efficiency doses nutrient_distribution].freeze
  INDEX_FIELD_HEADERS = %w[Sample Cultivo Fertigation Dosis DDT].freeze
  DOSES_INDEX_FIELDS = ['Kg/Ha', 'Maintenance dose Kg/Ha', 'Required dose'].freeze

  include CmAdmin::SoilEvaluationResult

  belongs_to :soil_evaluation_request

  delegate :producer_name, :parcel_name, :crop_name, to: :soil_evaluation_request, prefix: true, allow_nil: true

  RESULTS_TYPE.each do |result_type|
    has_many "#{result_type}_results".to_sym, lambda {
      where(result_type:).order(:id)
    }, class_name: 'SoilEvaluationNutrientResult', dependent: :destroy
  end

  def calculate
    RESULTS_TYPE.each do |result_type|
      send("#{result_type}_results").destroy_all
      send("calculate_#{result_type}")
    end
  end

  def calculate_supply_of_nutrient
    supply_of_nutrient_results.find_or_create_by!(index_field: soil_evaluation_request.parcel_name,
                                                  result_type: 'supply_of_nutrient').calculate
  end

  def calculate_crop_demand
    crop_demand_results.find_or_create_by!(index_field: soil_evaluation_request.crop_name,
                                           result_type: 'crop_demand').calculate
    crop_demand_results.find_or_create_by!(index_field: 'Nutrient needs in kg to meet the productivity goal',
                                           result_type: 'crop_demand').calculate
  end

  def calculate_fertilization_efficiency
    field_value = soil_evaluation_request.fertigation ? 'Yes' : 'No'
    fertilization_efficiency_results.find_or_create_by!(index_field: field_value,
                                                        result_type: 'fertilization_efficiency').calculate
  end

  def calculate_doses
    DOSES_INDEX_FIELDS.each do |index_field|
      doses_results.find_or_create_by!(index_field:, result_type: 'doses').calculate
    end
  end

  def calculate_nutrient_distribution
    soil_evaluation_request.crop.stages.each do |stage|
      nutrient_distribution_results.find_or_create_by!(result_type: 'nutrient_distribution',
                                                       index_field: stage).calculate
    end
    nutrient_distribution_results.find_or_create_by!(result_type: 'nutrient_distribution',
                                                     index_field: 'Total').calculate
  end
end
