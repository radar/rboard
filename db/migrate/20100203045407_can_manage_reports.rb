class CanManageReports < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_reports, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_reports
  end
end
