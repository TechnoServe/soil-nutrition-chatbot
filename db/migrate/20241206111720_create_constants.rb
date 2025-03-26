class CreateConstants < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'citext'
    create_table :constants do |t|
      t.citext :name
      t.integer :constant_type
      t.bigint :parent_id
      t.integer :position
      t.jsonb :meta, default: {}
      t.string :slug

      t.timestamps
    end
  end
end
