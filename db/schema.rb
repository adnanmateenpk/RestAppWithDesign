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

ActiveRecord::Schema.define(version: 20150211014640) do

  create_table "branches", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "slug",             limit: 255
    t.string   "address",          limit: 255
    t.string   "phone",            limit: 255
    t.string   "fax",              limit: 255
    t.string   "email",            limit: 255
    t.string   "featured_image",   limit: 255
    t.integer  "position",         limit: 4
    t.boolean  "status",           limit: 1
    t.datetime "open"
    t.datetime "close"
    t.integer  "seating_capacity", limit: 4
    t.integer  "expiry",           limit: 4
    t.integer  "restaurant_id",    limit: 4
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "time_zone",        limit: 255
  end

  add_index "branches", ["close"], name: "index_branches_on_close", using: :btree
  add_index "branches", ["open"], name: "index_branches_on_open", using: :btree
  add_index "branches", ["position"], name: "index_branches_on_position", using: :btree
  add_index "branches", ["restaurant_id"], name: "index_branches_on_restaurant_id", using: :btree
  add_index "branches", ["slug"], name: "index_branches_on_slug", using: :btree
  add_index "branches", ["user_id"], name: "index_branches_on_user_id", using: :btree

  create_table "ips", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.integer  "visits",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ips", ["visits"], name: "index_ips_on_visits", using: :btree

  create_table "layouts", force: :cascade do |t|
    t.string   "layout",     limit: 255
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "slug",             limit: 255
    t.text     "html",             limit: 65535
    t.integer  "layout_id",        limit: 4
    t.string   "featured_image",   limit: 255
    t.integer  "position",         limit: 4
    t.boolean  "status",           limit: 1
    t.string   "meta_keywords",    limit: 255
    t.string   "meta_description", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "pages", ["layout_id"], name: "index_pages_on_layout_id", using: :btree
  add_index "pages", ["position"], name: "index_pages_on_position", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree
  add_index "pages", ["status"], name: "index_pages_on_status", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "slug",             limit: 255
    t.text     "html",             limit: 65535
    t.string   "featured_image",   limit: 255
    t.integer  "position",         limit: 4
    t.boolean  "status",           limit: 1
    t.string   "meta_keywords",    limit: 255
    t.string   "meta_description", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "posts", ["position"], name: "index_posts_on_position", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree
  add_index "posts", ["status"], name: "index_posts_on_status", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.string   "reservation_name", limit: 255
    t.string   "reservation_code", limit: 255
    t.boolean  "status",           limit: 1
    t.integer  "branch_id",        limit: 4
    t.string   "user_id",          limit: 255
    t.integer  "people",           limit: 4
    t.datetime "booking"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "expire_at"
    t.integer  "created_by",       limit: 4
  end

  add_index "reservations", ["booking"], name: "index_reservations_on_booking", using: :btree
  add_index "reservations", ["branch_id"], name: "index_reservations_on_branch_id", using: :btree
  add_index "reservations", ["created_by"], name: "index_reservations_on_created_by", using: :btree
  add_index "reservations", ["status"], name: "index_reservations_on_status", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "slug",           limit: 255
    t.string   "featured_image", limit: 255
    t.integer  "user_id",        limit: 4
    t.text     "description",    limit: 65535
    t.boolean  "status",         limit: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "restaurants", ["slug"], name: "index_restaurants_on_slug", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "role",  limit: 255
    t.string "title", limit: 255
  end

  create_table "settings", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "logo",             limit: 255
    t.string   "email",            limit: 255
    t.string   "company_name",     limit: 255
    t.string   "phone",            limit: 255
    t.string   "fax",              limit: 255
    t.string   "address",          limit: 255
    t.string   "meta_keywords",    limit: 255
    t.text     "meta_description", limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "slot"
    t.integer  "seats",      limit: 4
    t.integer  "branch_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "time_slots", ["branch_id"], name: "index_time_slots_on_branch_id", using: :btree
  add_index "time_slots", ["slot"], name: "index_time_slots_on_slot", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "role_id",                limit: 4
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "phone",                  limit: 255
    t.string   "membership",             limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["membership"], name: "index_users_on_membership", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
