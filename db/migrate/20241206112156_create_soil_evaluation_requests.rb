class CreateSoilEvaluationRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :soil_evaluation_requests do |t|
      t.references :creator, foreign_key: { to_table: :users }
      t.references :crop, foreign_key: { to_table: :constants }
      t.references :state, foreign_key: { to_table: :constants }
      t.references :desired_productivity, foreign_key: { to_table: :constants }
      t.references :organic_matter, foreign_key: { to_table: :constants }
      t.string :producer_name
      t.string :parcel_name
      t.boolean :fertigation
      t.decimal :ph
      t.decimal :electrical_conductivity
      t.decimal :organic_matter_value
      t.decimal :sampling_depth
      t.string :texture
      t.decimal :apparent_density
      t.decimal :nitrogen_ppm
      t.decimal :phosphorus_ppm
      t.decimal :potassium_ppm
      t.decimal :calcium_ppm
      t.decimal :magnesium_ppm
      t.decimal :sulfur_ppm
      t.decimal :iron_ppm
      t.decimal :copper_ppm
      t.decimal :manganese_ppm
      t.decimal :zinc_ppm
      t.decimal :boron_ppm
      t.decimal :cation_exchange_capacity
      t.decimal :calcium_percentage
      t.decimal :magnesium_percentage
      t.decimal :potassium_percentage
      t.decimal :sodium_percentage
      t.decimal :hydrogen_percentage
      t.decimal :aluminum_percentage
      t.timestamps
    end
  end
end
