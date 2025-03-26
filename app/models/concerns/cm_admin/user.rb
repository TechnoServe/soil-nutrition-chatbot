module CmAdmin
  module User
    extend ActiveSupport::Concern
    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-user'
        cm_index do
          page_title 'User'

          filter %i[email first_name last_name], :search, placeholder: 'Search'
          filter :created_at, :date, placeholder: 'Created at'
          filter :updated_at, :date, placeholder: 'Updated at'

          sort_column :created_at
          sort_direction :desc

          column :full_name
          column :email
          column :cm_role_name, header: 'Role'
          column :created_at, field_type: :date, format: '%d %b, %Y'
          column :updated_at, field_type: :date, format: '%d %b, %Y', header: 'Last Updated At'
        end

        cm_show page_title: :full_name do
          tab :profile, '' do
            cm_show_section 'User Details' do
              field :email
              field :first_name
              field :last_name
              field :cm_role_name, label: 'Role'
            end
            cm_show_section 'Log Details' do
              field :created_at, field_type: :date, format: '%d %b, %Y'
              field :updated_at, field_type: :date, format: '%d %b, %Y', label: 'Last Updated At'
            end
          end
        end

        cm_new page_title: 'Add User', page_description: 'Enter all details to add User' do
          cm_section 'Details' do
            form_field :email, input_type: :string
            form_field :first_name, input_type: :string
            form_field :last_name, input_type: :string
            form_field :cm_role_id, input_type: :single_select, helper_method: :select_options_for_cm_role,
                                    label: 'Role', placeholder: 'Select Role'
          end
        end

        cm_edit page_title: 'Edit User', page_description: 'Enter all details to edit User' do
          cm_section 'Details' do
            form_field :email, input_type: :string
            form_field :first_name, input_type: :string
            form_field :last_name, input_type: :string
            form_field :cm_role_id, input_type: :single_select, helper_method: :select_options_for_cm_role,
                                    label: 'Role', placeholder: 'Select Role'
          end
        end
      end
    end
  end
end
