class CreateConfigs < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :key
      t.string :value
    end
  end

  def self.down
    drop_table :configurations
  end
end
