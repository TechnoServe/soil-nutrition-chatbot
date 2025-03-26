class CreateCropNutrientRequirements < ActiveRecord::Migration[8.0]
  def change
    create_table :crop_nutrient_requirements do |t|
      t.references :crop, foreign_key: { to_table: :constants }
      t.references :nutrient, foreign_key: { to_table: :constants }
      t.references :unit, foreign_key: { to_table: :constants }
      t.decimal :stage1
      t.decimal :stage2
      t.decimal :stage3
      t.decimal :stage4
      t.decimal :stage5
      t.decimal :stage6
      t.decimal :requirement_per_ton
      t.decimal :total_requirement
      t.decimal :performance

      t.timestamps
    end
  end
end
