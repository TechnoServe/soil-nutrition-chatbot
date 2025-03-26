class ChangeConstantTranslationsNameType < ActiveRecord::Migration[8.0]
  def change
    change_column :constant_translations, :name, :citext
  end
end
