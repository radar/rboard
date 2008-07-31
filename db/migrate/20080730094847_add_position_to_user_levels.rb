class AddPositionToUserLevels < ActiveRecord::Migration
  def self.up
    add_column :user_levels, :position, :integer
  end

  def self.down
    remove_column :user_levels, :position
  end
end
