class ManageThemes < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_themes, :boolean, :default => false 
  end

  def self.down
    remove_column :permissions, :can_manage_themes
  end
end
