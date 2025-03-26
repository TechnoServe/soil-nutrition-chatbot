class CreateDeliverable1aRows < ActiveRecord::Migration[8.0]
  def change
    remove_reference :deliverable1as, :amendment, foreign_key: { to_table: :constants }
    remove_column :deliverable1as, :first_element_name, :string
    remove_column :deliverable1as, :second_element_name, :string
    remove_column :deliverable1as, :first_element_value, :string
    remove_column :deliverable1as, :second_element_value, :string
    rename_table :deliverable1as, :inorganic_recommendations

    create_table :inorganic_recommendation_rows do |t|
      t.references :inorganic_recommendation
      t.references :amendment, foreign_key: { to_table: :constants }
      t.boolean :result
      t.string :first_element_name
      t.string :second_element_name
      t.string :first_element_amount
      t.string :second_element_amount

      t.timestamps
    end
  end
end
