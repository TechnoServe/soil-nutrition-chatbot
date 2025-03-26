class AddDeliverable2aTableName < ActiveRecord::Migration[8.0]
  def change
    rename_table :deliverable2as, :organic_recommendations
  end
end
