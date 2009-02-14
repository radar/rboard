class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.boolean :can_see_forum, :default => false
      t.boolean :can_reply_to_topics, :default => false
      t.boolean :can_post_stickies, :default => false
      t.boolean :can_start_new_topics, :default => false
      t.boolean :can_use_signature, :default => false
      t.boolean :can_delete_own_posts, :default => false
      t.boolean :can_edit_own_posts, :default => false
      t.boolean :can_subscribe, :default => false
      t.boolean :can_lock_own_topics, :default => false
      t.boolean :can_ignore_flood_limit , :default => false
      t.boolean :can_delete_posts, :default => false
      t.boolean :can_edit_posts, :default => false
      t.boolean :can_lock_topics, :default => false
      t.boolean :can_merge_topics, :default => false
      t.boolean :can_move_topics, :default => false
      t.boolean :can_split_topics, :default => false
      t.boolean :can_send_multiple_messages, :default => false
      t.boolean :can_send_messages_to_groups, :default => false
      t.boolean :can_read_messages, :default => false
      t.boolean :can_read_private_messages, :default => false
      t.boolean :can_manage_groups, :default => false
      t.boolean :can_manage_bans, :default => false
      t.boolean :can_manage_ranks, :default => false
      t.boolean :can_manage_users, :default => false
      t.boolean :can_manage_forums, :default => false
      t.boolean :can_manage_categories, :default => false
    end
  end

  def self.down
    drop_table :permissions
  end
end
