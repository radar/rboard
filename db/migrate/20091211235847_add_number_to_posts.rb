class AddNumberToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :number, :integer, :default => 1
  end

  def self.down
    remove_column :posts, :number
  end
end
