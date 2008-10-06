class AddHiddenToEdits < ActiveRecord::Migration
  def self.up
    add_column :edits, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :edits, :hidden
  end
end
