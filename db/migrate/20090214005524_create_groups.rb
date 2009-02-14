class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.references :owner
    end
    
    create_table :groups_users, :id => false do |t|
      t.references :group, :user
    end
    
  end

  def self.down
    drop_table :groups
  end
end
