class AddEncryptedEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :encrypted_email, :string
  end

  def self.down
    remove_column :users, :encrypted_email, :string
  end
end
