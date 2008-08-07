class AddPositionToUserLevels < ActiveRecord::Migration
  def self.up
    add_column :user_levels, :position, :integer
    u = UserLevel.find_by_name("User")
    u.position = 1
    u.save(false)
    u = UserLevel.find_by_name("Moderator")
    u.position = 2
    u.save(false)
    u = UserLevel.find_by_name("Administrator")
    u.position = 3
    u.save(false)
    
  end

  def self.down
    remove_column :user_levels, :position
  end
end
