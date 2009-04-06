class CanManagePosts < ActiveRecord::Migration
  def self.up
    add_column :permissions, :can_manage_posts, :boolean, :default => false
  end

  def self.down
    remove_column :permissions, :can_manage_posts
  end
end
