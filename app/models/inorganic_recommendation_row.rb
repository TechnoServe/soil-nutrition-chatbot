class InorganicRecommendationRow < ApplicationRecord
  include CmAdmin::InorganicRecommendationRow

  belongs_to :inorganic_recommendation
  belongs_to :amendment, class_name: 'Constant'

  delegate :soil_evaluation_request, to: :inorganic_recommendation
  delegate :name, to: :amendment, prefix: true, allow_nil: true

  AMENDMENT_MAPPING = { 'Agricultural lime': { ph: { lt: 6 }, mg: { gt: 20 }, na: { lt: 5 } },
                        'Dolomite lime': { ph: { lt: 6 }, mg: { lt: 20 }, na: { lt: 5 } },
                        'Organic matter': { ph: { gt: 7 }, mg: { gt: 20 }, na: { lt: 5 } },
                        'First year agricultural gypsum and second year dolomite lime':
                          { ph: { lt: 6 }, mg: { lt: 20 }, na: { gt: 5 } },
                        'First year agricultural gypsum and second year organic matter':
                          { ph: { gt: 7 }, mg: { gt: 20 }, na: { gt: 5 } },
                        'Agricultural Gypsum': { ph: { lt: 6 }, mg: { gt: 20 }, na: { gt: 5 } } }.with_indifferent_access.freeze

  def calculate
    mapping = AMENDMENT_MAPPING[amendment.name]
    logical_test_result = calculate_logical_test(ph: mapping[:ph], mg: mapping[:mg], na: mapping[:na])
    update!(result: logical_test_result)
    return unless logical_test_result

    calculate_amount
  end

  def formatted_result
    if result
      'Apply Amendment'
    else
      'No'
    end
  end

  private

  def calculate_logical_test(ph:, mg:, na:)
    evaluate_expression(soil_evaluation_request.magnesium_percentage.to_f, mg) &&
      evaluate_expression(soil_evaluation_request.sodium_percentage.to_f, na) &&
      evaluate_expression(soil_evaluation_request.ph.to_f, ph)
  end

  def calculate_amount
    case amendment.name
    when 'Agricultural lime'
      update!(first_element_name: 'Agricultural lime', first_element_amount: calculate_agricultural_lime)
    when 'Dolomite lime'
      update!(first_element_name: 'Dolomite lime', first_element_amount: calculate_dolomite_lime)
    when 'Organic matter'
      update!(first_element_name: 'Organic matter')
    when 'First year agricultural gypsum and second year dolomite lime'
      update!(first_element_name: 'Gypsum', first_element_amount: calculate_gypsum,
              second_element_name: 'Dolomite lime', second_element_amount: calculate_dolomite_lime)
    when 'First year agricultural gypsum and second year organic matter'
      update!(first_element_name: 'Gypsum', first_element_amount: calculate_gypsum,
              second_element_name: 'Organic matter')
    when 'Agricultural Gypsum'
      update!(first_element_name: 'Gypsum', first_element_amount: calculate_gypsum)
    end
  end

  def calculate_agricultural_lime
    calcium_percentage_goal = 70
    productive_area = 50
    soil_calcium_percentage = soil_evaluation_request.calcium_percentage.to_f
    soil_cec = soil_evaluation_request.cation_exchange_capacity.to_f
    increment = calcium_percentage_goal - soil_calcium_percentage
    soil_cec_per_ca = (increment * soil_cec) / 100
    ppm = ((soil_cec_per_ca * 10) * (40 / 2))
    kg_ha_of_ca = ppm * soil_evaluation_request.sampling_depth.to_f * soil_evaluation_request.apparent_density.to_f * 0.1
    lime_calculation = kg_ha_of_ca * 2.5
    [((lime_calculation * productive_area) / 100).round(2), 0].max
  end

  def calculate_dolomite_lime
    magnesium_percentage_goal = 15
    soil_magnesium_percentage = soil_evaluation_request.magnesium_percentage.to_f
    soil_cec = soil_evaluation_request.cation_exchange_capacity.to_f
    productive_area = 50
    increment = magnesium_percentage_goal - soil_magnesium_percentage
    soil_cec_per_mg = (increment * soil_cec) / 100
    ppm = ((soil_cec_per_mg * 10) * (24.3 / 2))
    kg_ha_of_mg = ppm * soil_evaluation_request.sampling_depth.to_f * soil_evaluation_request.apparent_density.to_f * 0.1
    dolomite_lime_calculation = kg_ha_of_mg * 7.58
    [((dolomite_lime_calculation * productive_area) / 100).round(2), 0].max
  end

  def calculate_gypsum
    calcium_percentage_goal = 70
    soil_calcium_percentage = soil_evaluation_request.calcium_percentage.to_f
    soil_cec = soil_evaluation_request.cation_exchange_capacity.to_f
    productive_area = 50
    increment = calcium_percentage_goal - soil_calcium_percentage
    soil_cec_per_ca = (increment * soil_cec) / 100
    ppm = ((soil_cec_per_ca * 10) * (40 / 2))
    kg_ha_of_ca = ppm * soil_evaluation_request.sampling_depth.to_f * soil_evaluation_request.apparent_density.to_f * 0.1
    gypsum_calculation = kg_ha_of_ca * 4.25
    [((gypsum_calculation * productive_area) / 100).round(2), 0].max
  end

  def evaluate_expression(value, nutrient)
    case nutrient.keys.first.to_sym
    when :lt
      value < nutrient[:lt]
    when :gt
      value > nutrient[:gt]
    end
  end
end
