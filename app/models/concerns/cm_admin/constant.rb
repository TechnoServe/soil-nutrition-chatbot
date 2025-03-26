module CmAdmin
  module Constant
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Constant'

          filter %i[name slug], :search, placeholder: 'Search'
          filter :constant_type, :single_select, helper_method: :select_options_for_constant_types,
                                                 placeholder: 'Constant Type'

          column :name
          column :constant_type, header: 'Constant Type'
          column :parent_name
          column :slug
        end

        cm_show page_title: :name do
          tab :profile, '' do
            cm_section 'Constant details' do
              field :name
              field :constant_type, label: 'Constant Type'
              field :parent_name
              field :slug
              field :carbon_content, display_if: lambda(&:organic_matter?)
            end
          end
        end

        cm_new page_title: 'Add Constant', page_description: 'Enter all details to add Constant' do
          cm_section 'Details' do
            form_field :name, input_type: :string
            form_field :constant_type, input_type: :single_select, helper_method: :select_options_for_constant_types,
                                       placeholder: 'Select constant type'
            form_field :parent_id, input_type: :single_select, helper_method: :select_options_for_all_constants,
                                   placeholder: 'Select Parent'
            form_field :slug, input_type: :string
          end
        end

        cm_edit page_title: 'Edit Constant', page_description: 'Enter all details to edit Constant' do
          cm_section 'Details' do
            form_field :name, input_type: :string
            form_field :constant_type, input_type: :single_select, helper_method: :select_options_for_constant_types,
                                       placeholder: 'Select constant type'
            form_field :parent_id, input_type: :single_select, helper_method: :select_options_for_all_constants,
                                   placeholder: 'Select Parent'
            form_field :slug, input_type: :string
          end
        end
      end
    end
  end
end
