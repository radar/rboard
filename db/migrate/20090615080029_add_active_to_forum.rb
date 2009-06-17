class AddActiveToForum < ActiveRecord::Migration
  def self.up
    add_column :forums, :active, :boolean, :default => true
  end

  def self.down
    remove_column :forums, :active
  end
end
