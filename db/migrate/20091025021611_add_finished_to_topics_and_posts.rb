class AddFinishedToTopicsAndPosts < ActiveRecord::Migration
  def self.up
    add_column :topics, :finished, :boolean, :default => false
    add_column :posts, :finished, :boolean, :default => false
  end

  def self.down
  end
end
