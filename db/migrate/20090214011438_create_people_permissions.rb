class CreatePeoplePermissions < ActiveRecord::Migration
  def self.up
    create_table :people_permissions do |t|
      t.string :people_type
      t.integer :people_id, :permission_id, :forum_id
    end
  end

  def self.down
    drop_table :people_permissions
  end
end
