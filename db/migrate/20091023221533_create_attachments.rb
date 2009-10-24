class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.timestamps
      t.references :post
    end
    
    add_column :permissions, :can_use_attachments, :boolean, :default => false
  end

  def self.down
    drop_table :attachments
    remove_column :permissions, :can_use_attachments
  end
end
