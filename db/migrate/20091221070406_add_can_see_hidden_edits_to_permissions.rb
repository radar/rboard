class AddCanSeeHiddenEditsToPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_see_hidden_edits, :boolean, :default => false
    add_column :permissions, :can_silently_edit, :boolean, :default => false
  end

  def self.down
  end
end
