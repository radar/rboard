class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id, :position
    end
    
    add_column :forums, :category_id, :integer
  end

  def self.down
    drop_table :categories
    remove_column :forums, :category_id
  end
end
