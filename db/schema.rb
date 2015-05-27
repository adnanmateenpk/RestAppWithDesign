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

ActiveRecord::Schema.define(version: 20150527130739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "address"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "featured_image"
    t.integer  "position"
    t.boolean  "status"
    t.integer  "seating_capacity"
    t.integer  "expiry"
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "open"
    t.datetime "close"
    t.string   "time_zone"
    t.boolean  "night_club"
  end

  add_index "branches", ["position"], name: "index_branches_on_position", using: :btree
  add_index "branches", ["restaurant_id"], name: "index_branches_on_restaurant_id", using: :btree
  add_index "branches", ["slug"], name: "index_branches_on_slug", using: :btree
  add_index "branches", ["user_id"], name: "index_branches_on_user_id", using: :btree

  create_table "date_restrictions", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.date     "restricted_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "date_restrictions", ["restaurant_id"], name: "index_date_restrictions_on_restaurant_id", using: :btree

  create_table "ips", force: :cascade do |t|
    t.string   "address"
    t.integer  "visits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ips", ["visits"], name: "index_ips_on_visits", using: :btree

  create_table "layouts", force: :cascade do |t|
    t.string   "layout"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "html"
    t.integer  "layout_id"
    t.string   "featured_image"
    t.integer  "position"
    t.boolean  "status"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "pages", ["layout_id"], name: "index_pages_on_layout_id", using: :btree
  add_index "pages", ["position"], name: "index_pages_on_position", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree
  add_index "pages", ["status"], name: "index_pages_on_status", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "html"
    t.string   "featured_image"
    t.integer  "position"
    t.boolean  "status"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "posts", ["position"], name: "index_posts_on_position", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree
  add_index "posts", ["status"], name: "index_posts_on_status", using: :btree

  create_table "reservation_tables", force: :cascade do |t|
    t.integer  "table_id"
    t.integer  "reservation_id"
    t.datetime "booking"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "reservation_tables", ["reservation_id"], name: "index_reservation_tables_on_reservation_id", using: :btree
  add_index "reservation_tables", ["table_id"], name: "index_reservation_tables_on_table_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.string   "reservation_name"
    t.string   "reservation_code"
    t.integer  "branch_id"
    t.string   "user_id"
    t.integer  "people"
    t.datetime "booking"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "expire_at"
    t.integer  "created_by"
    t.integer  "restaurant_owner"
    t.integer  "status"
  end

  add_index "reservations", ["booking"], name: "index_reservations_on_booking", using: :btree
  add_index "reservations", ["branch_id"], name: "index_reservations_on_branch_id", using: :btree
  add_index "reservations", ["created_by"], name: "index_reservations_on_created_by", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "restaurant_customers", force: :cascade do |t|
    t.integer  "restaurant_owner_id"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "restaurant_customers", ["restaurant_owner_id"], name: "index_restaurant_customers_on_restaurant_owner_id", using: :btree
  add_index "restaurant_customers", ["user_id"], name: "index_restaurant_customers_on_user_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "user_id"
    t.text     "description"
    t.boolean  "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "featured_image"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "restaurants", ["slug"], name: "index_restaurants_on_slug", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.string "title"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "title"
    t.string   "logo"
    t.string   "email"
    t.string   "company_name"
    t.string   "phone"
    t.string   "fax"
    t.string   "address"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tables", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "seats"
    t.integer  "quantity"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tables", ["restaurant_id"], name: "index_tables_on_restaurant_id", using: :btree
  add_index "tables", ["seats"], name: "index_tables_on_seats", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "role_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone"
    t.string   "membership"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["membership"], name: "index_users_on_membership", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
