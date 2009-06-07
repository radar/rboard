class AddCanManageConfigurationsToPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_configurations, :boolean, :default => false
  end

  def self.down
  end
end
