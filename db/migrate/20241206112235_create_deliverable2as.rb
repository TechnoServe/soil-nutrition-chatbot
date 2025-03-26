class CreateDeliverable2as < ActiveRecord::Migration[8.0]
  def change
    create_table :deliverable2as do |t|
      t.references :soil_evaluation_request
      t.decimal :amount
      t.timestamps
    end
  end
end
