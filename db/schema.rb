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

ActiveRecord::Schema.define(:version => 20081127002448) do

  create_table "banned_ips", :force => true do |t|
    t.string   "ip"
    t.string   "reason"
    t.integer  "banned_by"
    t.datetime "ban_time"
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
  end

  create_table "forums", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.integer "is_visible_to_id"
    t.integer "topics_created_by_id"
    t.integer "position"
    t.integer "parent_id"
    t.integer "last_post_id"
    t.integer "last_post_forum_id"
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

  create_table "people", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "people", ["login"], :name => "index_people_on_login", :unique => true

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
  end

  add_index "posts", ["id", "topic_id"], :name => "index_posts_on_id_and_topic_id"

  create_table "ranks", :force => true do |t|
    t.string  "name"
    t.integer "posts_required"
    t.boolean "custom",         :default => false
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
  end

  add_index "topics", ["id", "forum_id"], :name => "index_topics_on_id_and_forum_id"

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
  end

  add_index "users", ["id", "user_level_id"], :name => "index_users_on_id_and_user_level_id"

end
