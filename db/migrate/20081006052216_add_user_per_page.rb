class AddUserPerPage < ActiveRecord::Migration
  def self.up
    add_column :users, :per_page, :integer, :default => 30
  end

  def self.down
    remove_column :users, :per_page
  end
end
