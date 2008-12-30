class AddIsVisibleToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :is_visible_to_id, :integer
  end

  def self.down
    remove_column :categories, :is_visible_to_id
  end
end
