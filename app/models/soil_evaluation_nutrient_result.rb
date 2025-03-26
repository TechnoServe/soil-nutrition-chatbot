class SoilEvaluationNutrientResult < ApplicationRecord
  include CmAdmin::SoilEvaluationNutrientResult

  belongs_to :soil_evaluation_result

  enum :result_type, ::SoilEvaluationResult::RESULTS_TYPE

  delegate :soil_evaluation_request, to: :soil_evaluation_result

  def calculate
    send("calculate_#{result_type}")
  end

  def calculate_supply_of_nutrient
    sampling_depth = soil_evaluation_request.sampling_depth.to_f
    apparent_density = soil_evaluation_request.apparent_density.to_f
    ::Constant.nutrient.each do |nutrient|
      result = case nutrient.name
               when 'N'
                 sampling_depth * apparent_density * soil_evaluation_request.nitrogen_ppm.to_f * 0.1
               when 'P2O5'
                 (sampling_depth * apparent_density * soil_evaluation_request.phosphorus_ppm.to_f * 0.1) * 2.2914
               when 'K2O'
                 (sampling_depth * apparent_density * soil_evaluation_request.potassium_ppm.to_f * 0.1) * 1.2046
               when 'CaO'
                 (sampling_depth * apparent_density * soil_evaluation_request.calcium_ppm.to_f * 0.1) * 1.3992
               when 'MgO'
                 (sampling_depth * apparent_density * soil_evaluation_request.magnesium_ppm.to_f * 0.1) * 1.6569
               when 'S'
                 (sampling_depth * apparent_density * soil_evaluation_request.sulfur_ppm.to_f * 0.1)
               when 'Fe'
                 (sampling_depth * apparent_density * soil_evaluation_request.iron_ppm.to_f * 0.1)
               when 'Zn'
                 (sampling_depth * apparent_density * soil_evaluation_request.zinc_ppm.to_f * 0.1)
               when 'Mn'
                 (sampling_depth * apparent_density * soil_evaluation_request.manganese_ppm.to_f * 0.1)
               when 'Cu'
                 (sampling_depth * apparent_density * soil_evaluation_request.copper_ppm.to_f * 0.1)
               when 'B'
                 (sampling_depth * apparent_density * soil_evaluation_request.boron_ppm.to_f * 0.1)
               end
      update!("#{nutrient.name.downcase}_amount" => result.round(2))
    end
  end

  def calculate_crop_demand
    ::Constant.nutrient.each do |nutrient|
      crop = soil_evaluation_request.crop
      desired_productivity = soil_evaluation_request.desired_productivity
      calculated_value = CropNutrientDemand.find_by(nutrient:, crop:).value.to_f
      unless index_field == soil_evaluation_request.crop_name
        productivity_amount = CropProduction.find_by(crop:, desired_productivity:).productivity.to_f
        calculated_value *= productivity_amount
      end
      update!("#{nutrient.name.downcase}_amount" => calculated_value.round(2))
    end
  end

  def calculate_fertilization_efficiency
    ::Constant.nutrient.each do |nutrient|
      value = if soil_evaluation_request.fertigation
                1.2
              else
                1.3
              end
      update!("#{nutrient.name.downcase}_amount" => value)
    end
  end

  def calculate_doses
    demand_results = soil_evaluation_result.crop_demand_results.find_by(index_field: 'Nutrient needs in kg to meet the productivity goal')
    supply_of_nutrient_results = soil_evaluation_result.supply_of_nutrient_results.last
    fertigation = soil_evaluation_request.fertigation ? 1.2 : 1.3
    ::Constant.nutrient.each do |nutrient|
      demand = demand_results.send("#{nutrient.name.downcase}_amount").to_f
      supply_of_nutrient = supply_of_nutrient_results.send("#{nutrient.name.downcase}_amount").to_f
      calculated_value = case index_field
                         when SoilEvaluationResult::DOSES_INDEX_FIELDS[0]
                           (demand - supply_of_nutrient) * fertigation
                         when SoilEvaluationResult::DOSES_INDEX_FIELDS[1]
                           demand * 0.1
                         when SoilEvaluationResult::DOSES_INDEX_FIELDS[2]
                           ((demand - supply_of_nutrient) * fertigation)
                         end
      update!("#{nutrient.name.downcase}_amount" => calculated_value.round(2))
    end
  end

  def calculate_nutrient_distribution
    if index_field == 'Total'
      ::Constant.nutrient.each do |nutrient|
        total_value = soil_evaluation_result.nutrient_distribution_results.sum("#{nutrient.name.downcase}_amount").round(2)
        soil_evaluation_result.nutrient_distribution_results.where.not(index_field: 'Total').each_with_index do |result, index|
          result_amount = result.send("#{nutrient.name.downcase}_amount")
          if index == 2
            calculated_value = format_nutrient_amount(nutrient, total_value, result_amount)
            result.update!("#{nutrient.name.downcase}_amount" => calculated_value)
          else
            result.update!("#{nutrient.name.downcase}_amount" => [result_amount, 0.0].max)
          end
        end
        total_value = soil_evaluation_result.nutrient_distribution_results.sum("#{nutrient.name.downcase}_amount").round(2)
        update!("#{nutrient.name.downcase}_amount" => total_value)
      end
      return
    end
    doses = soil_evaluation_result.doses_results.find_by(index_field: SoilEvaluationResult::DOSES_INDEX_FIELDS[2])
    index = soil_evaluation_request.crop.stages.index(index_field) + 1
    ::Constant.nutrient.each do |nutrient|
      stage_value = CropNutrientRequirement.find_by(crop: soil_evaluation_request.crop,
                                                    nutrient:).send("stage#{index}").to_f
      calculated_value = ((doses.send("#{nutrient.name.downcase}_amount").to_f * stage_value) / 100).round(2)
      update!("#{nutrient.name.downcase}_amount" => calculated_value)
    end
  end

  def translated_index_field
    return index_field unless nutrient_distribution? || crop_demand? || fertilization_efficiency?

    if fertilization_efficiency?
      return 'Si' if index_field == 'Yes'

      return index_field
    end

    if crop_demand?
      if index_field == 'Nutrient needs in kg to meet the productivity goal'
        return 'Necesidades de nutrientes en kg para alcanzar la meta de productividad'
      end

      return soil_evaluation_request.crop.spanish_translation.name
    end

    return 'Total' if index_field == 'Total'

    crop_translation = soil_evaluation_request.crop.spanish_translation
    idx = soil_evaluation_request.crop.stages.index { |stage| stage == index_field }
    crop_translation.stages[idx.to_i]
  end

  private

  def format_nutrient_amount(nutrient, value, result_amount)
    return result_amount if value.positive?
    if value < 0.0 && %w[p2o5 n k2o cao mgo s].exclude?(nutrient.name.downcase)
      return 0.0
    end
    return 0.0 if value < -5.0

    maintenance_dose = soil_evaluation_result.doses_results.find_by(index_field: SoilEvaluationResult::DOSES_INDEX_FIELDS[1])
    maintenance_dose.send("#{nutrient.name.downcase}_amount").to_f.round(2)
  end
end
