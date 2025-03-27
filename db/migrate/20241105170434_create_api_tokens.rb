class CreateApiTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :api_tokens do |t|
      t.string :token
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
