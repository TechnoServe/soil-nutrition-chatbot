module CmAdmin
  module SoilEvaluationRequest
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        cm_index do
          page_title 'Soil Evaluation Request'

          filter %i[producer_name parcel_name], :search, placeholder: 'Search'
          filter :crop_id, :single_select, helper_method: :select_options_for_crop
          filter :desired_productivity_id, :single_select, helper_method: :select_options_for_desired_productivity
          filter :state_id, :single_select, helper_method: :select_options_for_state
          filter :gender_id, :single_select, helper_method: :select_options_for_gender
          filter :age_range_id, :single_select, helper_method: :select_options_for_age_range

          custom_action name: 'generate_pdf', path: ':id/generate_pdf', verb: 'patch', route_type: 'member',
                        display_type: :button, display_name: 'Generate PDF' do
            soil_evaluation_request = ::SoilEvaluationRequest.find(params[:id])
            ::GenerateResultPdfJob.perform_later(soil_evaluation_request)
            soil_evaluation_request
          end

          column :id
          column :producer_name
          column :parcel_name
          column :crop_name
          column :desired_productivity_name
          column :state_name
          column :fertigation
        end

        cm_show page_title: 'Soil Evaluation Request' do
          tab :profile, '' do
            cm_section 'Soil Evaluation Request details' do
              field :producer_name
              field :parcel_name
              field :gender_name, label: 'Gender'
              field :age_range_name, label: 'Age Range'
              field :crop_name
              field :desired_productivity_name
              field :desired_productivity_amount
              field :state_name
              field :organic_matter_name
              field :fertigation
              field :ph, label: 'pH'
              field :electrical_conductivity, label: 'Electrical Conductivity (dS/m)'
              field :organic_matter_value, label: 'Organic Matter (%)'
              field :sampling_depth, label: 'Sampling Depth (cm)'
              field :texture
              field :apparent_density, label: 'Apparent Density (g/cm3)'
              field :nitrogen_ppm, label: 'Nitrogen (N-NH4 + N-NO3) (PPM)'
              field :phosphorus_ppm, label: 'Phosphorus (Bray) (PPM)'
              field :potassium_ppm, label: 'Potassium (PPM)'
              field :calcium_ppm, label: 'Calcium (PPM)'
              field :magnesium_ppm, label: 'Magnesium (PPM)'
              field :sulfur_ppm, label: 'Sulfur (PPM)'
              field :iron_ppm, label: 'Iron (PPM)'
              field :copper_ppm, label: 'Copper (PPM)'
              field :manganese_ppm, label: 'Manganese (PPM)'
              field :zinc_ppm, label: 'Zinc (PPM)'
              field :boron_ppm, label: 'Boron (PPM)'
              field :cation_exchange_capacity, label: 'Cation Exchange Capacity (cmol+/kg)'
              field :calcium_percentage, label: 'Calcium (%)'
              field :magnesium_percentage, label: 'Magnesium (%)'
              field :potassium_percentage, label: 'Potassium (%)'
              field :sodium_percentage, label: 'Sodium (%)'
              field :hydrogen_percentage, label: 'Hydrogen (%)'
              field :aluminum_percentage, label: 'Aluminum (%)'
            end
            cm_section 'Results' do
              field :result_pdf_url, field_type: :custom, helper_method: :file_url, label: 'Result PDF'
              field :spanish_result_pdf_url, field_type: :custom, helper_method: :file_url, label: 'Spanish Result PDF'
              field :inorganic_recommendation_url, field_type: :custom, helper_method: :evaluation_result_url, label: 'Inorganic Recommendation'
              field :organic_recommendation_url, field_type: :custom, helper_method: :evaluation_result_url, label: 'Organic Recommendation',
                                                 display_if: ->(obj) { obj.organic_recommendation.present? }
              field :soil_evaluation_result_url, field_type: :custom, helper_method: :evaluation_result_url, label: 'Soil Evaluation Result'
            end
          end
        end

        cm_new page_title: 'New Soil Evaluation Request',
               page_description: 'Enter all details to create Soil Evaluation Request' do
          cm_section 'Details' do
            form_field :producer_name
            form_field :parcel_name
            form_field :gender_id, input_type: :single_select, helper_method: :select_options_for_gender
            form_field :age_range_id, input_type: :single_select, helper_method: :select_options_for_age_range
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :desired_productivity_id, input_type: :single_select, placeholder: 'Select Desired Productivity',
                                                 helper_method: :select_options_for_desired_productivity
            form_field :state_id, input_type: :single_select, helper_method: :select_options_for_state
            form_field :organic_matter_id, input_type: :single_select, helper_method: :select_options_for_organic_matter
            form_field :fertigation, input_type: :switch
            form_field :ph, input_type: :decimal, label: 'pH'
            form_field :electrical_conductivity, input_type: :decimal, label: 'Electrical Conductivity (dS/m)'
            form_field :organic_matter_value, input_type: :decimal, label: 'Organic Matter (%)'
            form_field :sampling_depth, input_type: :decimal, label: 'Sampling Depth (cm)'
            form_field :texture
            form_field :apparent_density, input_type: :decimal, label: 'Apparent Density (g/cm3)'
            form_field :nitrogen_ppm, input_type: :decimal, label: 'Nitrogen (N-NH4 + N-NO3) (PPM)'
            form_field :phosphorus_ppm, input_type: :decimal, label: 'Phosphorus (Bray) (PPM)'
            form_field :potassium_ppm, input_type: :decimal, label: 'Potassium (PPM)'
            form_field :calcium_ppm, input_type: :decimal, label: 'Calcium (PPM)'
            form_field :magnesium_ppm, input_type: :decimal, label: 'Magnesium (PPM)'
            form_field :sulfur_ppm, input_type: :decimal, label: 'Sulfur (PPM)'
            form_field :iron_ppm, input_type: :decimal, label: 'Iron (PPM)'
            form_field :copper_ppm, input_type: :decimal, label: 'Copper (PPM)'
            form_field :manganese_ppm, input_type: :decimal, label: 'Manganese (PPM)'
            form_field :zinc_ppm, input_type: :decimal, label: 'Zinc (PPM)'
            form_field :boron_ppm, input_type: :decimal, label: 'Boron (PPM)'
            form_field :cation_exchange_capacity, input_type: :decimal, label: 'Cation Exchange Capacity (cmol+/kg)'
            form_field :calcium_percentage, input_type: :decimal, label: 'Calcium (%)'
            form_field :magnesium_percentage, input_type: :decimal, label: 'Magnesium (%)'
            form_field :potassium_percentage, input_type: :decimal, label: 'Potassium (%)'
            form_field :sodium_percentage, input_type: :decimal, label: 'Sodium (%)'
            form_field :hydrogen_percentage, input_type: :decimal, label: 'Hydrogen (%)'
            form_field :aluminum_percentage, input_type: :decimal, label: 'Aluminum (%)'
          end
        end

        cm_edit page_title: 'Edit Soil Evaluation Request',
                page_description: 'Enter all details to edit Soil Evaluation Request' do
          cm_section 'Details' do
            form_field :producer_name
            form_field :parcel_name
            form_field :gender_id, input_type: :single_select, helper_method: :select_options_for_gender
            form_field :age_range_id, input_type: :single_select, helper_method: :select_options_for_age_range
            form_field :crop_id, input_type: :single_select, helper_method: :select_options_for_crop,
                                 placeholder: 'Select Crop'
            form_field :desired_productivity_id, input_type: :single_select, placeholder: 'Select Desired Productivity',
                                                 helper_method: :select_options_for_desired_productivity
            form_field :state_id, input_type: :single_select, helper_method: :select_options_for_state
            form_field :organic_matter_id, input_type: :single_select, helper_method: :select_options_for_organic_matter
            form_field :fertigation, input_type: :switch
            form_field :ph, input_type: :decimal, label: 'pH'
            form_field :electrical_conductivity, input_type: :decimal, label: 'Electrical Conductivity (dS/m)'
            form_field :organic_matter_value, input_type: :decimal, label: 'Organic Matter (%)'
            form_field :sampling_depth, input_type: :decimal, label: 'Sampling Depth (cm)'
            form_field :texture
            form_field :apparent_density, input_type: :decimal, label: 'Apparent Density (g/cm3)'
            form_field :nitrogen_ppm, input_type: :decimal, label: 'Nitrogen (N-NH4 + N-NO3) (PPM)'
            form_field :phosphorus_ppm, input_type: :decimal, label: 'Phosphorus (Bray) (PPM)'
            form_field :potassium_ppm, input_type: :decimal, label: 'Potassium (PPM)'
            form_field :calcium_ppm, input_type: :decimal, label: 'Calcium (PPM)'
            form_field :magnesium_ppm, input_type: :decimal, label: 'Magnesium (PPM)'
            form_field :sulfur_ppm, input_type: :decimal, label: 'Sulfur (PPM)'
            form_field :iron_ppm, input_type: :decimal, label: 'Iron (PPM)'
            form_field :copper_ppm, input_type: :decimal, label: 'Copper (PPM)'
            form_field :manganese_ppm, input_type: :decimal, label: 'Manganese (PPM)'
            form_field :zinc_ppm, input_type: :decimal, label: 'Zinc (PPM)'
            form_field :boron_ppm, input_type: :decimal, label: 'Boron (PPM)'
            form_field :cation_exchange_capacity, input_type: :decimal, label: 'Cation Exchange Capacity (cmol+/kg)'
            form_field :calcium_percentage, input_type: :decimal, label: 'Calcium (%)'
            form_field :magnesium_percentage, input_type: :decimal, label: 'Magnesium (%)'
            form_field :potassium_percentage, input_type: :decimal, label: 'Potassium (%)'
            form_field :sodium_percentage, input_type: :decimal, label: 'Sodium (%)'
            form_field :hydrogen_percentage, input_type: :decimal, label: 'Hydrogen (%)'
            form_field :aluminum_percentage, input_type: :decimal, label: 'Aluminum (%)'
          end
        end
      end
    end
  end
end
