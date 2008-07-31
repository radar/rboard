class ChangeIsVisibleToToId < ActiveRecord::Migration
  def self.up
    rename_column :forums, :is_visible_to, :is_visible_to_id
    rename_column :forums, :topics_created_by, :topics_created_by_id
    
  end

  def self.down
    rename_column :forums, :is_visible_to_id, :is_visible_to
    rename_column :forums, :topics_created_by_id, :topics_created_by
  end
end
