class RemoveIdFromUserLevel < ActiveRecord::Migration
  def self.up
    remove_column :user_levels, :id
  end

  def self.down
    add_column :user_levels, :id, :integer 
  end
end
