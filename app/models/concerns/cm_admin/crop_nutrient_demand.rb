module CmAdmin
  module CropNutrientDemand
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Crop Nutrient Demand'

          filter %i[value], :search, placeholder: 'Search'
          filter :crop_id, :single_select, helper_method: :select_options_for_crop
          filter :nutrient_id, :single_select, helper_method: :select_options_for_nutrient

          column :crop_name
          column :nutrient_name
          column :value
        end

        cm_show page_title: 'Crop Nutrient Demand' do
          tab :profile, '' do
            cm_section 'Crop Nutrient Demand details' do
              field :crop_name
              field :nutrient_name
              field :value
            end
          end
        end

        cm_new page_title: 'New Crop Nutrient Demand',
               page_description: 'Enter all details to create Crop Nutrient Demand' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :nutrient_id, input_type: :single_select, placeholder: 'Select Nutrient',
                                     helper_method: :select_options_for_nutrient
            form_field :value, input_type: :decimal
          end
        end

        cm_edit page_title: 'Edit Crop Nutrient Demand',
                page_description: 'Enter all details to edit Crop Nutrient Demand' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :nutrient_id, input_type: :single_select, placeholder: 'Select Nutrient',
                                     helper_method: :select_options_for_nutrient
            form_field :value, input_type: :decimal
          end
        end
      end
    end
  end
end
