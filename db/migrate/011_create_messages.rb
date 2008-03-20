class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.column :from_id, :integer
      t.column :from_read, :boolean, :default => 0
      t.column :from_deleted, :boolean, :default => 0
      t.column :to_id, :integer
      t.column :to_read, :boolean, :default => 0
      t.column :to_deleted, :boolean, :default => 0
      t.column :text, :text
      t.column :created_at, :datetime
    end
  end
  
  def self.down
    drop_table :messages
  end
end
