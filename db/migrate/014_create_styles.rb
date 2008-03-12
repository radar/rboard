
class CreateStyles < ActiveRecord::Migration

  def self.up
    create_table :styles do |t|
    t.column :name, :string
    t.column :css, :text
    t.column :is_default, :boolean, :default => false
    end
    
    add_column :users, :style_id, :integer, :efault => 1
  end

  def self.down
    drop_table :styles
  end
end
