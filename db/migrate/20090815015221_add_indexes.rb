class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :permissions, :forum_id
    add_index :permissions, :group_id
    add_index :permissions, :category_id
    
    add_index :categories, :parent_id
    add_index :forums, :parent_id
    
    add_index :banned_ips, :ban_time
    
    add_index :users, :login
    add_index :users, :login_time
  end

  def self.down
  end
end
