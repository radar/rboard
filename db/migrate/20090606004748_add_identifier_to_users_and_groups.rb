class AddIdentifierToUsersAndGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :identifier, :string
    add_column :users, :identifier, :string
  end

  def self.down
    remove_column :users, :identifier
    remove_column :groups, :identifier
  end
end
