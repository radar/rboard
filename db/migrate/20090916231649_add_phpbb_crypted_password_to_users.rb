class AddPhpbbCryptedPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phpbb_crypted_password, :string
  end

  def self.down
    remove_column :users, :phpbb_crypted_password
  end
end
