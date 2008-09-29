class CreateEdits < ActiveRecord::Migration
  def self.up
    create_table :edits do |t|
      t.integer :user_id, :post_id
      t.string :ip
      t.text :original_content, :current_content
      t.timestamps
    end
  end

  def self.down
    drop_table :edits
  end
end
