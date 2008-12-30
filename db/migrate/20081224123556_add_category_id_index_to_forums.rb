class AddCategoryIdIndexToForums < ActiveRecord::Migration
  def self.up
    add_index :forums, :category_id
  end

  def self.down
    remove_index :forums, :category_id
  end
end
