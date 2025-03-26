class CreateSoilEvaluationResults < ActiveRecord::Migration[8.0]
  def change
    create_table :soil_evaluation_results do |t|
      t.references :soil_evaluation_request
      t.references :nutrient, foreign_key: { to_table: :constants }
      t.decimal :value
      t.integer :result_type
      t.timestamps
    end
  end
end
