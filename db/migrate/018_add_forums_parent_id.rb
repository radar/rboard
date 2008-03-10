class AddForumsParentId < ActiveRecord::Migration
  def self.up
    add_column :forums, :parent_id, :integer
  end

  def self.down
    remove_column :forums, :parent_id
  end
end
