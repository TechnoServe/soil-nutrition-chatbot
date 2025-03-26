class CreateCropProductions < ActiveRecord::Migration[8.0]
  def change
    create_table :crop_productions do |t|
      t.references :crop, foreign_key: { to_table: :constants }
      t.references :desired_productivity, foreign_key: { to_table: :constants }
      t.decimal :productivity
      t.timestamps
    end
  end
end
