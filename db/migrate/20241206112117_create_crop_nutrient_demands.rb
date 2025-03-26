class CreateCropNutrientDemands < ActiveRecord::Migration[8.0]
  def change
    create_table :crop_nutrient_demands do |t|
      t.references :crop, foreign_key: { to_table: :constants }
      t.references :nutrient, foreign_key: { to_table: :constants }
      t.decimal :value
      t.timestamps
    end
  end
end
