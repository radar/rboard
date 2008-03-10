class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :location
      t.text :description, :disclaimer
      t.boolean :open
      t.datetime :start, :end
   end
  end

  def self.down
    drop_table :events
  end
end