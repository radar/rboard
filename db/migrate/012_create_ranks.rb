class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
    t.column "name", :string
    t.column "posts_required", :integer
    t.column "custom", :boolean, :default => false
    end
    add_column :users, :rank_id, :integer
  end

  def self.down
    drop_table :ranks
    remove_column :users, :rank_id
  end
end
