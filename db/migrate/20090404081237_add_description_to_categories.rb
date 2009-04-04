class AddDescriptionToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :description, :string
  end

  def self.down
    remove_column :categories, :description
  end
end
