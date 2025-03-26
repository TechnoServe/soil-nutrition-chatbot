module CmAdmin
  module OrganicRecommendation
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions except: %i[edit new]
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Organic Recommendation'

          filter %i[], :search, placeholder: 'Search'

          column :soil_evaluation_request_producer_name
          column :soil_evaluation_request_parcel_name
          column :soil_evaluation_request_organic_matter_name
          column :amount, header: 'Amount in Kg/ha'
        end

        cm_show page_title: 'Organic Recommendation' do
          tab :profile, '' do
            cm_section 'Result' do
              field :soil_evaluation_request_producer_name
              field :soil_evaluation_request_parcel_name
              field :soil_evaluation_request_organic_matter_name
              field :amount, label: 'Amount in Kg/ha'
            end
          end
        end
      end
    end
  end
end
