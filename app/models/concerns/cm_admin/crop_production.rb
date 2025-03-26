module CmAdmin
  module CropProduction
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Crop Production'

          filter %i[productivity], :search, placeholder: 'Search'
          filter :crop_id, :single_select, helper_method: :select_options_for_crop
          filter :desired_productivity_id, :single_select, helper_method: :select_options_for_desired_productivity

          column :crop_name
          column :desired_productivity_name
          column :productivity
        end

        cm_show page_title: 'Crop Production' do
          tab :profile, '' do
            cm_section 'Crop Production details' do
              field :crop_name
              field :desired_productivity_name
              field :productivity
            end
          end
        end

        cm_new page_title: 'New Crop Production', page_description: 'Enter all details to create Crop Production' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :desired_productivity_id, input_type: :single_select, placeholder: 'Select Desired Productivity',
                                                 helper_method: :select_options_for_desired_productivity
            form_field :productivity, input_type: :decimal
          end
        end

        cm_edit page_title: 'Edit Crop Production', page_description: 'Enter all details to edit Crop Production' do
          cm_section 'Details' do
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :desired_productivity_id, input_type: :single_select, placeholder: 'Select Desired Productivity',
                                                 helper_method: :select_options_for_desired_productivity
            form_field :productivity, input_type: :decimal
          end
        end
      end
    end
  end
end
