class CreateModerations < ActiveRecord::Migration
  def self.up
    create_table :moderations do |t|
      t.integer :moderated_object_id
      t.string :moderated_object_type
      t.references :user 
      t.string :reason
      t.timestamps
    end
  end

  def self.down
    drop_table :moderations
  end
end
