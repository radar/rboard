class CanSeeInactiveForums < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_see_inactive_forums, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_see_inactive_forums
  end
end
