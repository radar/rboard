class RemoveUserPermissions < ActiveRecord::Migration
  def self.up
    drop_table :user_permissions
    drop_table :group_permissions
    
    add_column :permissions, :group_id, :integer
    add_column :permissions, :forum_id, :integer
    add_column :permissions, :category_id, :integer
    
    # And some other cleanup...
    
    drop_table :people
  end

  def self.down
    raise IrreversibleMigration
  end
end
