class AddCategoryToPeoplePermissions < ActiveRecord::Migration
  def self.up
    add_column :people_permissions, :category_id, :integer
    drop_table :people_permissions
    
    create_table :user_permissions do |t|
      t.integer :user_id, :permission_id, :forum_id, :category_id
    end
    
    create_table :group_permissions do |t|
      t.integer :group_id, :permission_id, :forum_id, :category_id
    end
  end

  def self.down
    remove_column :people_permissions, :category_id
  end
end
