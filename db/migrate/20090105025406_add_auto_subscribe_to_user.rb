class AddAutoSubscribeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :auto_subscribe, :boolean, :default => true
  end

  def self.down
    remove_column :users, :auto_subscribe
  end
end
