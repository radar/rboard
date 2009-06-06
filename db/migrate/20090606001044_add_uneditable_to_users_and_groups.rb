class AddUneditableToUsersAndGroups < ActiveRecord::Migration
  def self.up
    add_column :users, :uneditable, :boolean, :default => false
    add_column :groups, :uneditable, :boolean, :default => false
  end

  def self.down
    remove_column :groups, :uneditable
    remove_column :users, :uneditable
  end
end
