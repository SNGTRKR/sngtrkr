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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140209131650) do

  create_table "artists", force: true do |t|
    t.string   "name",                          null: false
    t.string   "genre"
    t.text     "bio"
    t.string   "hometown"
    t.string   "booking_email"
    t.string   "manager_email"
    t.string   "website"
    t.string   "soundcloud"
    t.string   "youtube"
    t.string   "sdigital"
    t.string   "juno"
    t.string   "label_name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "fbid"
    t.boolean  "ignore",        default: false, null: false
    t.string   "twitter"
    t.integer  "itunes_id"
  end

  add_index "artists", ["ignore"], name: "index_artists_on_ignore", using: :btree

  create_table "follows", force: true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "follows", ["user_id", "artist_id"], name: "index_follows_on_user_id_and_artist_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "release_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "sent",       default: false
    t.datetime "sent_at"
  end

  create_table "releases", force: true do |t|
    t.string   "name",                       null: false
    t.datetime "date",                       null: false
    t.string   "cat_no"
    t.string   "itunes"
    t.string   "sdigital"
    t.string   "amazon"
    t.string   "juno"
    t.string   "youtube"
    t.integer  "artist_id",                  null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "label_name"
    t.boolean  "scraped"
    t.string   "genre"
    t.integer  "itunes_id"
    t.boolean  "ignore",     default: false, null: false
    t.boolean  "tweet"
  end

  add_index "releases", ["date", "artist_id"], name: "index_releases_on_date_and_artist_id", using: :btree
  add_index "releases", ["ignore"], name: "index_releases_on_ignore_and_upc", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "suggests", force: true do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.boolean  "ignore"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "suggests", ["user_id", "artist_id"], name: "index_suggests_on_user_id_and_artist_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "type"
    t.integer  "email_frequency"
    t.datetime "last_email"
    t.string   "username"
    t.integer  "role"
    t.text     "fbid"
    t.integer  "leave_reason"
    t.date     "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["fbid"], name: "index_users_on_fbid", length: {"fbid"=>20}, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
