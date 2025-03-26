module CmAdmin
  module SoilEvaluationResult
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions except: %i[edit new]
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Soil Evaluation Result'

          filter %i[], :search, placeholder: 'Search'

          column :soil_evaluation_request_producer_name
          column :soil_evaluation_request_parcel_name
          column :soil_evaluation_request_crop_name
        end

        cm_show page_title: '1a Deliverable' do
          tab :profile, '' do
            cm_section 'Soil Evaluation Request' do
              field :soil_evaluation_request_producer_name
              field :soil_evaluation_request_parcel_name
              field :soil_evaluation_request_crop_name
            end
            ::SoilEvaluationResult::RESULTS_TYPE.each_with_index do |result_type, index|
              cm_section result_type.to_s.titleize do
                nested_form_field "#{result_type}_results".to_sym do
                  field :index_field, label: ::SoilEvaluationResult::INDEX_FIELD_HEADERS[index]
                  field :n_amount, label: 'N (kg)'
                  field :p2o5_amount, label: 'P2O5 (kg)'
                  field :k2o_amount, label: 'K2O (kg)'
                  field :cao_amount, label: 'CaO (kg)'
                  field :mgo_amount, label: 'MgO (kg)'
                  field :s_amount, label: 'S (kg)'
                  field :fe_amount, label: 'Fe (g)'
                  field :zn_amount, label: 'Zn (g)'
                  field :mn_amount, label: 'Mn (g)'
                  field :cu_amount, label: 'Cu (g)'
                  field :b_amount, label: 'B (g)'
                end
              end
            end
          end
        end
      end
    end
  end
end
