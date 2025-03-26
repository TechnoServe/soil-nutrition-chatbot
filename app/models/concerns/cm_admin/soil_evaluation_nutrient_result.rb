module CmAdmin
  module SoilEvaluationNutrientResult
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        visible_on_sidebar false

        cm_index do
          page_title 'SoilEvaluationNutrientResult'
        end
      end
    end
  end
end
