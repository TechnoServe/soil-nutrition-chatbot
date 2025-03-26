class AddCmRoleToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :cm_role, foreign_key: true
  end
end
