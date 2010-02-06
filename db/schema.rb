# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100204214710) do

  create_table "banned_ips", :force => true do |t|
    t.string   "ip"
    t.string   "reason"
    t.integer  "banned_by"
    t.datetime "ban_time"
  end

  add_index "banned_ips", ["ban_time"], :name => "index_banned_ips_on_ban_time"

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "position"
    t.integer "is_visible_to_id"
    t.string  "description"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "configurations", :force => true do |t|
    t.string "key"
    t.string "value"
    t.text   "description"
    t.string "title"
  end

  create_table "edits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "ip"
    t.text     "original_content"
    t.text     "current_content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",           :default => false
    t.integer  "ip_id"
  end

  add_index "edits", ["ip_id"], :name => "index_edits_on_ip_id"

  create_table "forums", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.integer "is_visible_to_id"
    t.integer "topics_created_by_id"
    t.integer "position"
    t.integer "parent_id"
    t.integer "last_post_id"
    t.integer "last_post_forum_id"
    t.integer "topics_count",         :default => 0
    t.integer "posts_count",          :default => 0
    t.integer "category_id"
    t.boolean "active",               :default => true
    t.boolean "open",                 :default => true
  end

  add_index "forums", ["category_id"], :name => "index_forums_on_category_id"
  add_index "forums", ["open"], :name => "index_forums_on_open"
  add_index "forums", ["parent_id"], :name => "index_forums_on_parent_id"
  add_index "forums", ["posts_count"], :name => "index_forums_on_posts_count"
  add_index "forums", ["topics_count"], :name => "index_forums_on_topics_count"

  create_table "group_users", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.integer "owner_id"
    t.string  "identifier"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "ip_users", :force => true do |t|
    t.integer  "ip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ips", :force => true do |t|
    t.string   "ip",         :limit => 15
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "from_id"
    t.boolean  "from_read",    :default => false
    t.boolean  "from_deleted", :default => false
    t.integer  "to_id"
    t.boolean  "to_read",      :default => false
    t.boolean  "to_deleted",   :default => false
    t.text     "text"
    t.datetime "created_at"
  end

  create_table "moderations", :force => true do |t|
    t.integer  "moderated_object_id"
    t.string   "moderated_object_type"
    t.integer  "user_id"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
  end

  create_table "permissions", :force => true do |t|
    t.boolean "can_see_forum",                    :default => false
    t.boolean "can_reply_to_topics",              :default => false
    t.boolean "can_post_stickies",                :default => false
    t.boolean "can_start_new_topics",             :default => false
    t.boolean "can_use_signature",                :default => false
    t.boolean "can_delete_own_posts",             :default => false
    t.boolean "can_edit_own_posts",               :default => false
    t.boolean "can_subscribe",                    :default => false
    t.boolean "can_lock_own_topics",              :default => false
    t.boolean "can_ignore_flood_limit",           :default => false
    t.boolean "can_delete_posts",                 :default => false
    t.boolean "can_edit_posts",                   :default => false
    t.boolean "can_lock_topics",                  :default => false
    t.boolean "can_merge_topics",                 :default => false
    t.boolean "can_move_topics",                  :default => false
    t.boolean "can_split_topics",                 :default => false
    t.boolean "can_send_multiple_messages",       :default => false
    t.boolean "can_send_messages_to_groups",      :default => false
    t.boolean "can_read_private_messages",        :default => false
    t.boolean "can_manage_groups",                :default => false
    t.boolean "can_manage_bans",                  :default => false
    t.boolean "can_manage_ranks",                 :default => false
    t.boolean "can_manage_users",                 :default => false
    t.boolean "can_manage_forums",                :default => false
    t.boolean "can_manage_categories",            :default => false
    t.boolean "can_reply_to_locked_topics",       :default => false
    t.boolean "can_edit_topics",                  :default => false
    t.boolean "can_reply",                        :default => false
    t.boolean "can_edit_locked_topics",           :default => false
    t.boolean "can_access_admin_section",         :default => false
    t.boolean "can_see_category",                 :default => false
    t.boolean "can_access_moderator_section",     :default => false
    t.integer "group_id"
    t.integer "forum_id"
    t.integer "category_id"
    t.boolean "default",                          :default => false
    t.boolean "can_manage_themes",                :default => false
    t.boolean "can_edit_own_topics",              :default => false
    t.boolean "can_manage_ips",                   :default => false
    t.boolean "can_manage_posts",                 :default => false
    t.boolean "can_manage_topics",                :default => false
    t.boolean "can_manage_edits",                 :default => false
    t.boolean "can_delete_topics",                :default => false
    t.boolean "can_manage_moderations",           :default => false
    t.boolean "can_read_others_private_messages", :default => false
    t.boolean "can_manage_configurations",        :default => false
    t.boolean "can_see_inactive_forums",          :default => false
    t.boolean "can_post_in_closed_forums",        :default => false
    t.boolean "can_see_hidden_edits",             :default => false
    t.boolean "can_silently_edit",                :default => false
    t.boolean "can_manage_permissions",           :default => false
    t.boolean "can_manage_reports",               :default => false
    t.boolean "can_sticky_topics",                :default => false
  end

  add_index "permissions", ["category_id"], :name => "index_permissions_on_category_id"
  add_index "permissions", ["forum_id"], :name => "index_permissions_on_forum_id"
  add_index "permissions", ["group_id"], :name => "index_permissions_on_group_id"

  create_table "post_attachments", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "post_id"
  end

  create_table "posts", :force => true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "edited_by_id"
    t.string   "edit_reason"
    t.boolean  "delta"
    t.boolean  "deleted",      :default => false
    t.integer  "ip_id"
    t.integer  "number",       :default => 1
  end

  add_index "posts", ["id", "topic_id"], :name => "index_posts_on_id_and_topic_id"
  add_index "posts", ["ip_id"], :name => "index_posts_on_ip_id"

  create_table "ranks", :force => true do |t|
    t.string  "name"
    t.integer "posts_required"
    t.boolean "custom",         :default => false
  end

  create_table "read_topics", :force => true do |t|
    t.integer "user_id"
    t.integer "topic_id"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "posts_count"
    t.integer  "integer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string  "name"
    t.boolean "is_default", :default => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at"
    t.boolean  "locked",       :default => false
    t.integer  "views",        :default => 0
    t.boolean  "sticky",       :default => false
    t.integer  "last_post_id"
    t.boolean  "delta"
    t.boolean  "deleted",      :default => false
    t.integer  "ip_id"
    t.boolean  "moved",        :default => false
    t.integer  "moved_to_id"
  end

  add_index "topics", ["id", "forum_id"], :name => "index_topics_on_id_and_forum_id"
  add_index "topics", ["ip_id"], :name => "index_topics_on_ip_id"

  create_table "user_levels", :id => false, :force => true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "previous_login"
    t.string   "signature"
    t.datetime "login_time"
    t.integer  "banned_by"
    t.datetime "ban_time"
    t.string   "ban_reason"
    t.integer  "ban_times",                               :default => 0
    t.string   "location"
    t.text     "description"
    t.text     "website"
    t.integer  "rank_id"
    t.integer  "user_level_id",                           :default => 1
    t.integer  "theme_id"
    t.string   "ip",                        :limit => 15
    t.string   "date_display",                            :default => "%d %B %Y"
    t.string   "time_display",                            :default => "%I:%M:%S%P"
    t.integer  "per_page",                                :default => 30
    t.string   "encrypted_email"
    t.string   "time_zone"
    t.string   "display_name"
    t.string   "permalink"
    t.boolean  "auto_subscribe",                          :default => true
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.string   "identifier"
  end

  add_index "users", ["id", "user_level_id"], :name => "index_users_on_id_and_user_level_id"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["login_time"], :name => "index_users_on_login_time"

end
