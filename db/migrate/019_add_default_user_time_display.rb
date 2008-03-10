class AddDefaultUserTimeDisplay < ActiveRecord::Migration
  def self.up
    add_column :users, :time_display, :string, :default => "%d %B %Y %I:%M:%S%P"
  end

  def self.down
    remove_column :users, :time_display
  end
end
