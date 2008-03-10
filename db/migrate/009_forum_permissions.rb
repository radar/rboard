class ForumPermissions < ActiveRecord::Migration
  def self.up
   add_column :forums, :is_visible_to, :integer, :default => 1
   add_column :forums, :topics_created_by, :integer, :default => 1
   remove_column :users, :admin
   add_column :users, :userlvl, :integer, :default => 1
  end

  def self.down
  remove_column :forums, :is_visible_to
  remove_column :forums, :topics_created_by
  add_column :users, :admin, :integer, :default => 0
  remove_column :users, :userlvl
  end
end
