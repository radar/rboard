class AddCanManagePermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_permissions, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_permissions
  end
end
