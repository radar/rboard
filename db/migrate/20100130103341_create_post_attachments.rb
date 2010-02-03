class CreatePostAttachments < ActiveRecord::Migration
  def self.up
    create_table :post_attachments do |t|
      t.string   :file_file_name, :file_content_type
      t.integer  :avatar_file_size
      t.datetime :avatar_updated_at
      t.references :post
    end
  end

  def self.down
    drop_table :post_attachments
  end
end
