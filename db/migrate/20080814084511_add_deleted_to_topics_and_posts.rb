class AddDeletedToTopicsAndPosts < ActiveRecord::Migration
  def self.up
    add_column :topics, :deleted, :boolean, :default => false
    add_column :posts, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :topics, :deleted
    remove_column :posts, :deleted
  end
end
