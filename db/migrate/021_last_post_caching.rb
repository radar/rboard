class LastPostCaching < ActiveRecord::Migration
  def self.up
    add_column :forums, :last_post_id, :integer
    add_column :topics, :last_post_id, :integer
    add_column :forums, :last_post_forum_id, :integer
  end

  def self.down
    remove_column :forums, :last_post_id, :integer
    remove_column :forums, :last_post_id, :integer
    remove_column :forums, :last_post_forum_id, :integer
  end
end
