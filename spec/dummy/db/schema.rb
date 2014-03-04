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

ActiveRecord::Schema.define(version: 20140304094052) do

  create_table "no_cms_pages_block_translations", force: true do |t|
    t.integer "no_cms_pages_block_id"
    t.string  "locale"
    t.string  "layout"
    t.text    "fields_info",           default: "--- {}\n"
  end

  add_index "no_cms_pages_block_translations", ["no_cms_pages_block_id"], name: "index_no_cms_pages_block_translations_on_no_cms_pages_block_id"

  create_table "no_cms_pages_blocks", force: true do |t|
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "no_cms_pages_blocks", ["page_id"], name: "index_no_cms_pages_blocks_on_page_id"

  create_table "no_cms_pages_page_translations", force: true do |t|
    t.integer "no_cms_pages_page_id"
    t.string  "locale"
    t.string  "title"
    t.string  "body"
    t.string  "slug"
    t.string  "path"
  end

  add_index "no_cms_pages_page_translations", ["no_cms_pages_page_id"], name: "index_no_cms_pages_page_translations_on_no_cms_pages_page_id"

  create_table "no_cms_pages_pages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "template"
  end

  create_table "test_images", force: true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
