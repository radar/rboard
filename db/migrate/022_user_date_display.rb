class UserDateDisplay < ActiveRecord::Migration
  def self.up
    add_column :users, :date_display, :string, :default => "%d %B %Y"
    remove_column :users, :time_display
    add_column :users, :time_display, :string, :default => "%I:%M:%S%P"
  end

  def self.down
    remove_column :users, :date_display
    add_column :users, :time_display, :string
  end
end
