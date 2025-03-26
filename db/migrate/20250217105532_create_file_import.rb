class CreateFileImport < ActiveRecord::Migration[8.0]
  def change
    create_table :file_imports do |t|
      t.string :associated_model_name
      t.references :added_by, polymorphic: true, null: false
      t.jsonb :error_report, default: {}
      t.datetime :completed_at
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
