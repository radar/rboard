class SomeMoreUserStuff < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
    add_column :users, :description, :text
    add_column :users, :website, :text
  end
  
  def self.down
    remove_column :users, :location
    remove_column :users, :description
    remove_column :users, :website
  end
end
