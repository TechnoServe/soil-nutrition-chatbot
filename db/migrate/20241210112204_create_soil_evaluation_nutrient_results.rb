class CreateSoilEvaluationNutrientResults < ActiveRecord::Migration[8.0]
  def change
    remove_reference :soil_evaluation_results, :nutrient
    remove_column :soil_evaluation_results, :value, :decimal
    remove_column :soil_evaluation_results, :result_type, :integer

    create_table :soil_evaluation_nutrient_results do |t|
      t.references :soil_evaluation_result
      t.string :index_field
      t.decimal :n_amount
      t.decimal :p2o5_amount
      t.decimal :k2o_amount
      t.decimal :cao_amount
      t.decimal :mgo_amount
      t.decimal :s_amount
      t.decimal :fe_amount
      t.decimal :zn_amount
      t.decimal :mn_amount
      t.decimal :cu_amount
      t.decimal :b_amount
      t.integer :result_type
      t.timestamps
    end
  end
end
