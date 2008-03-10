class RenameStylesToThemes < ActiveRecord::Migration
  def self.up
    rename_table :styles, :themes
    rename_column :users, :style_id, :theme_id
    remove_column :themes, :css
  end

  def self.down
    rename_table :themes, :styles
    rename_column :users, :theme_id, :style_id
    add_column :themes, :css, :text
  end
end
