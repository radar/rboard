class CreateEdits < ActiveRecord::Migration
  def self.up
    create_table :edits do |t|
      t.column "text", :text
      t.column "version", :integer
      t.column "user_id", :integer
      t.column "post_id", :integer
    end
  end
  
  def self.down
    drop_table :edits
  end
end
