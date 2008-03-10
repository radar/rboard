class TrackUserIps < ActiveRecord::Migration
  def self.up
    add_column :users, :ip, :string, :limit => 15
  end

  def self.down
    remove_column :users, :ip
  end
end
