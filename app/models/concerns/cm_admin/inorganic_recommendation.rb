module CmAdmin
  module InorganicRecommendation
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions except: %i[edit new]
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Inorganic Recommendation'

          filter %i[], :search, placeholder: 'Search'

          column :soil_evaluation_request_producer_name
          column :soil_evaluation_request_parcel_name
          column :soil_evaluation_request_crop_name
        end

        cm_show page_title: 'Inorganic Recommendation' do
          tab :profile, '' do
            cm_section 'Soil Evaluation Request' do
              field :soil_evaluation_request_producer_name
              field :soil_evaluation_request_parcel_name
              field :soil_evaluation_request_crop_name
            end
            cm_section 'Inorganic Recommendation details' do
              nested_form_field :inorganic_recommendation_rows, label: 'Result' do
                field :amendment_name
                field :formatted_result, label: 'Result'
                field :first_element_name, label: 'Recommended Amendment Name'
                field :first_element_amount, label: 'Amount in Kg/Ha'
                field :second_element_name, label: 'Recommended Amendment Name'
                field :second_element_amount, label: 'Amount in Kg/Ha'
              end
            end
          end
        end
      end
    end
  end
end
