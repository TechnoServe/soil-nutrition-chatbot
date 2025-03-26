class AddTransalationTables < ActiveRecord::Migration[8.0]
  def change
    create_table :constant_translations do |t|
      t.references :constant, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :name
      t.jsonb :meta, default: {}
      t.index %i[constant_id locale], unique: true
      t.timestamps
    end
  end
end
