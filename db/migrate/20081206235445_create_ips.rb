class CreateIps < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.string :ip, :limit => 15
      t.timestamps
    end
    
    create_table :ip_users do |t|
      t.references :ip
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :ips
    drop_table :ip_users
  end
end
