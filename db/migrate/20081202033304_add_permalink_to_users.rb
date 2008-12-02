class AddPermalinkToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :permalink, :string
  end

  def self.down
    remove_column :users, :permalink
  end
end
