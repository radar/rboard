class AddCounterForTopicsToForum < ActiveRecord::Migration
  def self.up
    add_column :forums, :topics_count, :integer, :default => 0
    add_column :forums, :posts_count, :integer, :default => 0
    add_index :forums, :topics_count
    add_index :forums, :posts_count
  end

  def self.down
    remove_column :forums, :topics_count
    remove_column :forums, :posts_count
  end
end
