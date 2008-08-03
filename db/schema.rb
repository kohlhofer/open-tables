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

ActiveRecord::Schema.define(:version => 20080731220602) do

  create_table "goldberg_content_pages", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.integer  "markup_style_id", :limit => 11
    t.text     "content"
    t.integer  "permission_id",   :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_cache"
    t.string   "markup_style"
  end

  add_index "goldberg_content_pages", ["permission_id"], :name => "fk_content_page_permission_id"
  add_index "goldberg_content_pages", ["markup_style_id"], :name => "fk_content_page_markup_style_id"

  create_table "goldberg_controller_actions", :force => true do |t|
    t.integer "site_controller_id", :limit => 11
    t.string  "name"
    t.integer "permission_id",      :limit => 11
    t.string  "url_to_use"
  end

  add_index "goldberg_controller_actions", ["permission_id"], :name => "fk_controller_action_permission_id"
  add_index "goldberg_controller_actions", ["site_controller_id"], :name => "fk_controller_action_site_controller_id"

  create_table "goldberg_menu_items", :force => true do |t|
    t.integer "parent_id",            :limit => 11
    t.string  "name"
    t.string  "label"
    t.integer "seq",                  :limit => 11
    t.integer "controller_action_id", :limit => 11
    t.integer "content_page_id",      :limit => 11
  end

  add_index "goldberg_menu_items", ["controller_action_id"], :name => "fk_menu_item_controller_action_id"
  add_index "goldberg_menu_items", ["content_page_id"], :name => "fk_menu_item_content_page_id"
  add_index "goldberg_menu_items", ["parent_id"], :name => "fk_menu_item_parent_id"

  create_table "goldberg_permissions", :force => true do |t|
    t.string "name", :default => ""
  end

  create_table "goldberg_roles", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id",       :limit => 11
    t.string   "description",                   :default => "", :null => false
    t.integer  "default_page_id", :limit => 11
    t.text     "cache"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "start_path"
  end

  add_index "goldberg_roles", ["parent_id"], :name => "fk_role_parent_id"
  add_index "goldberg_roles", ["default_page_id"], :name => "fk_role_default_page_id"

  create_table "goldberg_roles_permissions", :force => true do |t|
    t.integer "role_id",       :limit => 11
    t.integer "permission_id", :limit => 11
  end

  add_index "goldberg_roles_permissions", ["role_id"], :name => "fk_roles_permission_role_id"
  add_index "goldberg_roles_permissions", ["permission_id"], :name => "fk_roles_permission_permission_id"

  create_table "goldberg_site_controllers", :force => true do |t|
    t.string  "name"
    t.integer "permission_id", :limit => 11
    t.integer "builtin",       :limit => 11, :default => 0
  end

  add_index "goldberg_site_controllers", ["permission_id"], :name => "fk_site_controller_permission_id"

  create_table "goldberg_system_settings", :force => true do |t|
    t.string  "site_name"
    t.string  "site_subtitle"
    t.string  "footer_message",                                    :default => ""
    t.integer "public_role_id",                      :limit => 11
    t.integer "session_timeout",                     :limit => 11, :default => 0,  :null => false
    t.integer "site_default_page_id",                :limit => 11
    t.integer "not_found_page_id",                   :limit => 11
    t.integer "permission_denied_page_id",           :limit => 11
    t.integer "session_expired_page_id",             :limit => 11
    t.integer "menu_depth",                          :limit => 11, :default => 0,  :null => false
    t.string  "start_path"
    t.string  "site_url_prefix"
    t.boolean "self_reg_enabled"
    t.integer "self_reg_role_id",                    :limit => 11
    t.boolean "self_reg_confirmation_required"
    t.integer "self_reg_confirmation_error_page_id", :limit => 11
    t.boolean "self_reg_send_confirmation_email"
  end

  add_index "goldberg_system_settings", ["public_role_id"], :name => "fk_system_settings_public_role_id"
  add_index "goldberg_system_settings", ["site_default_page_id"], :name => "fk_system_settings_site_default_page_id"
  add_index "goldberg_system_settings", ["not_found_page_id"], :name => "fk_system_settings_not_found_page_id"
  add_index "goldberg_system_settings", ["permission_denied_page_id"], :name => "fk_system_settings_permission_denied_page_id"
  add_index "goldberg_system_settings", ["session_expired_page_id"], :name => "fk_system_settings_session_expired_page_id"

  create_table "goldberg_users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.integer  "role_id",                        :limit => 11
    t.string   "password_salt"
    t.string   "fullname"
    t.string   "email"
    t.string   "start_path"
    t.boolean  "self_reg_confirmation_required"
    t.string   "confirmation_key"
    t.datetime "password_changed_at"
    t.boolean  "password_expired"
    t.string   "website"
  end

  add_index "goldberg_users", ["role_id"], :name => "fk_user_role_id"

  create_table "items", :force => true do |t|
    t.string   "type",                                        :null => false
    t.string   "title"
    t.string   "source"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                :default => true,  :null => false
    t.boolean  "spam",                     :default => false, :null => false
    t.integer  "user_id",    :limit => 11
  end

  create_table "items_topics", :force => true do |t|
    t.integer "item_id",  :limit => 11, :null => false
    t.integer "topic_id", :limit => 11, :null => false
  end

  create_table "plugin_schema_migrations", :id => false, :force => true do |t|
    t.string "plugin_name", :null => false
    t.string "version",     :null => false
  end

  add_index "plugin_schema_migrations", ["plugin_name", "version"], :name => "unique_schema_migrations", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11
    t.integer  "taggable_id",   :limit => 11
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "title",                        :null => false
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
