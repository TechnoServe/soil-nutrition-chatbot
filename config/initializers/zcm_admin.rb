Rails.application.reloader.to_prepare do
  CmAdmin.configure do |config|
    # Sets the default layout to be used for admin
    config.layout = 'admin'
    # config.authorized_roles = [:super_admin?]
    config.included_models = [Constant, User, CmRole, CropProduction, CropNutrientDemand, CropNutrientRequirement,
                              SoilEvaluationRequest, InorganicRecommendation, InorganicRecommendationRow,
                              OrganicRecommendation, SoilEvaluationResult, SoilEvaluationNutrientResult]
    config.project_name = Rails.configuration.x.project_settings.name
    config.enable_tracking = true
    config.sidebar = [
      {
        display_name: 'User Management',
        icon_name: 'fa fa-database',
        children: [
          {
            display_name: 'Users',
            path: :cm_index_user_path,
            display_if: ->(_) { true }
          },
          {
            display_name: 'Roles',
            path: :cm_index_cm_role_path
          }
        ]
      },
      {
        display_name: 'Content Management',
        icon_name: 'fa fa-file-text',
        children: [
          {
            display_name: 'Constant',
            path: :cm_index_constant_path
          },
          {
            display_name: 'Crop Production',
            path: :cm_index_crop_production_path
          },
          {
            display_name: 'Crop Nutrient Demand',
            path: :cm_index_crop_nutrient_demand_path
          },
          {
            display_name: 'Crop Nutrient Requirement',
            path: :cm_index_crop_nutrient_requirement_path
          }
        ]
      },
      {
        display_name: 'Soil Evaluation Request',
        path: :cm_index_soil_evaluation_request_path
      },
      {
        display_name: 'Results',
        icon_name: 'fa fa-file-text',
        children: [
          {
            display_name: 'Inorganic Recommendation',
            path: :cm_index_inorganic_recommendation_path
          },
          {
            display_name: 'Organic Recommendation',
            path: :cm_index_organic_recommendation_path
          },
          {
            display_name: 'Soil Evaluation Result',
            path: :cm_index_soil_evaluation_result_path
          }
        ]
      }
    ]
  end
end
