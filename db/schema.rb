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

ActiveRecord::Schema.define(version: 20150203145919) do

  create_table "branches", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "slug",           limit: 255
    t.string   "address",        limit: 255
    t.string   "phone",          limit: 255
    t.string   "fax",            limit: 255
    t.string   "email",          limit: 255
    t.string   "featured_image", limit: 255
    t.integer  "position",       limit: 4
    t.boolean  "status",         limit: 1
    t.integer  "restaurant_id",  limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "branches", ["position"], name: "index_branches_on_position", using: :btree
  add_index "branches", ["restaurant_id"], name: "index_branches_on_restaurant_id", using: :btree
  add_index "branches", ["slug"], name: "index_branches_on_slug", using: :btree

  create_table "ips", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.integer  "visits",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ips", ["visits"], name: "index_ips_on_visits", using: :btree

  create_table "layouts", force: :cascade do |t|
    t.string   "layout",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
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

  create_table "tables", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "slug",           limit: 255
    t.integer  "chairs",         limit: 4
    t.integer  "branch_id",      limit: 4
    t.string   "featured_image", limit: 255
    t.integer  "position",       limit: 4
    t.boolean  "status",         limit: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "tables", ["branch_id"], name: "index_tables_on_branch_id", using: :btree
  add_index "tables", ["position"], name: "index_tables_on_position", using: :btree
  add_index "tables", ["slug"], name: "index_tables_on_slug", using: :btree

end
