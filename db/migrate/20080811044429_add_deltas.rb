class AddDeltas < ActiveRecord::Migration
  def self.up
    add_column :topics, :delta, :boolean
    add_column :posts, :delta, :boolean
  end

  def self.down
    remove_column :topics, :delta, :boolean
    remove_column :posts, :delta, :boolean
  end
end
