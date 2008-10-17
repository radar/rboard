class AddIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :posts, [:id, :topic_id]
    add_index :topics, [:id, :forum_id]
    add_index :users, [:id, :user_level_id]
  end

  def self.down
  end
end
