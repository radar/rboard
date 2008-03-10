class OtherUserStuff < ActiveRecord::Migration
  def self.up
    add_column :users, :login_time, :datetime
    add_column :users, :banned_by, :integer
    add_column :users, :ban_time, :datetime
    add_column :users, :ban_reason, :string
    add_column :users, :ban_times, :integer, :default => 0
    create_table :banned_ips do |t|
      t.column 'ip', :string
      t.column 'reason', :string
      t.column 'banned_by', :integer
      t.column 'ban_time', :datetime
    end
  end
  
  def self.down
    remove_column :users, :login_time
    remove_column :users, :banned_by
    remove_column :users, :ban_time
    remove_column :users, :ban_reason
    remove_column :users, :ban_times
    drop_table :banned_ips
  end
end
