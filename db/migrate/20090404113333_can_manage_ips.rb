class CanManageIps < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_ips, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_ips
  end
end
