# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120513211059) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "genre"
    t.text     "bio"
    t.string   "hometown"
    t.string   "booking_email"
    t.string   "manager_email"
    t.string   "website"
    t.string   "soundcloud"
    t.string   "youtube"
    t.integer  "label_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "fbid"
    t.boolean  "ignore"
    t.text     "twitter"
    t.text     "label_name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "itunes"
    t.text     "sdid"
    t.text     "sd"
  end

  create_table "follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "sdigital"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "manages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "releases", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.string   "cat_no"
    t.string   "itunes"
    t.string   "sdigital"
    t.string   "amazon"
    t.string   "youtube"
    t.integer  "rls_type"
    t.integer  "artist_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "label_name"
    t.integer  "label_id"
    t.integer  "scraped"
    t.text     "sd_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "suggests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.boolean  "ignore"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "super_manages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "label_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "release_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "type"
    t.integer  "email_frequency"
    t.datetime "last_email"
    t.string   "username"
    t.integer  "role"
    t.text     "fbid"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
