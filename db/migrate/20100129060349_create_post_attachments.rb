class CreatePostAttachments < ActiveRecord::Migration
  def self.up
    create_table :post_attachments do |t|
      t.references :post
      t.string   :avatar_file_name,    :string
      t.string   :avatar_content_type, :string
      t.integer  :avatar_file_size,    :integer
      t.datetime :avatar_updated_at,   :datetime
    end
    
    add_column :posts, :draft, :boolean, :default => true
  end

  def self.down
    drop_table :post_attachments
  end
end
