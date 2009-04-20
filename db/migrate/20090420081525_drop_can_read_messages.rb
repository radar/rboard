class DropCanReadMessages < ActiveRecord::Migration
  def self.up
    remove_column :permissions, :can_read_messages
  end

  def self.down
  end
end
