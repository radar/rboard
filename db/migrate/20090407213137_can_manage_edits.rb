class CanManageEdits < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_edits, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_edits
  end
end
