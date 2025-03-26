class AddDefaultRedirectPathToCmRole < ActiveRecord::Migration[7.2]
  def change
    add_column :cm_roles, :default_redirect_path, :string, default: "#{CmAdmin::Engine.mount_path}/users"
  end
end
