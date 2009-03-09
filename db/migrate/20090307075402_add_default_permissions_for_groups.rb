class AddDefaultPermissionsForGroups < ActiveRecord::Migration
  def self.up
    add_column :permissions, :default, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :default
  end
end
