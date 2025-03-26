class AddAgeRangeAndGenderToRequest < ActiveRecord::Migration[8.0]
  def change
    add_reference :soil_evaluation_requests, :age_range, foreign_key: { to_table: :constants }
    add_reference :soil_evaluation_requests, :gender, foreign_key: { to_table: :constants }
  end
end
