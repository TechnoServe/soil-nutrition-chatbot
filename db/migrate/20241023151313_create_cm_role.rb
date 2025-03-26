class CreateCmRole < ActiveRecord::Migration[7.2]
  def change
    create_table :cm_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
