class CreateDeliverable1as < ActiveRecord::Migration[8.0]
  def change
    create_table :deliverable1as do |t|
      t.references :soil_evaluation_request
      t.references :amendment, foreign_key: { to_table: :constants }
      t.string :first_element_name
      t.decimal :first_element_value
      t.string :second_element_name
      t.decimal :second_element_value
      t.timestamps
    end
  end
end
