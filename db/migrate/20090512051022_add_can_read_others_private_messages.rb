class AddCanReadOthersPrivateMessages < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_read_others_private_messages, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_read_others_private_messages
  end
end
