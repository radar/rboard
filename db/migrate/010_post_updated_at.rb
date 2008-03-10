class PostUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :posts, :edited_by_id, :integer
    add_column :posts, :edit_reason, :string
  end
  
  def self.down
    remove_column :posts, :edited_by_id
    remove_column :posts, :edit_reason
  end
end
