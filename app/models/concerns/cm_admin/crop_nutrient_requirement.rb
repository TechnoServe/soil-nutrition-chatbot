module CmAdmin
  module CropNutrientRequirement
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Crop Nutrient Requirement'

          filter %i[performance total_requirement requirement_per_ton], :search, placeholder: 'Search'
          filter :crop_id, :single_select, helper_method: :select_options_for_crop
          filter :nutrient_id, :single_select, helper_method: :select_options_for_nutrient

          column :crop_name
          column :nutrient_name
          column :requirement_per_ton
          column :performance
          column :total_requirement
        end

        cm_show page_title: 'Crop Nutrient Requirement' do
          tab :profile, '' do
            cm_section 'Crop Nutrient Requirement details' do
              field :crop_name
              field :nutrient_name
              field :unit_name
              field :requirement_per_ton
              field :performance
              field :total_requirement
              (1..6).to_a.each do |i|
                field "stage#{i}_value".to_sym, display_if: ->(obj) { obj.crop.stages[i - 1].present? }
              end
            end
          end
        end

        cm_new page_title: 'New Crop Nutrient Requirement',
               page_description: 'Enter all details to create Crop Nutrient Requirement' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :nutrient_id, input_type: :single_select, placeholder: 'Select Nutrient',
                                     helper_method: :select_options_for_nutrient
            form_field :requirement_per_ton, input_type: :decimal
            form_field :performance, input_type: :decimal
            form_field :total_requirement, input_type: :decimal
            (1..6).to_a.each do |i|
              form_field "stage#{i}".to_sym, input_type: :decimal
            end
          end
        end

        cm_edit page_title: 'Edit Crop Nutrient Requirement',
                page_description: 'Enter all details to edit Crop Nutrient Requirement' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :nutrient_id, input_type: :single_select, placeholder: 'Select Nutrient',
                                     helper_method: :select_options_for_nutrient
            form_field :requirement_per_ton, input_type: :decimal
            form_field :performance, input_type: :decimal
            form_field :total_requirement, input_type: :decimal
            (1..6).to_a.each do |i|
              form_field "stage#{i}".to_sym, input_type: :decimal, display_if: ->(obj) { obj.crop.stages[i - 1].present? }
            end
          end
        end
      end
    end
  end
end
