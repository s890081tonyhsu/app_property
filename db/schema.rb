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

ActiveRecord::Schema.define(version: 20140419083021) do

  create_table "items", force: true do |t|
    t.string   "ItemName"
    t.integer  "ItemNum"
    t.integer  "ItemHeavy"
    t.integer  "ItemStatus"
    t.text     "ItemDescription"
    t.integer  "ItemDeadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["ItemName"], name: "index_Items_on_ItemName", unique: true, using: :btree

  create_table "lends", force: true do |t|
    t.string   "LendName"
    t.string   "LendEmail"
    t.integer  "ItemId"
    t.integer  "ItemLendStatus"
    t.date     "PassTime"
    t.date     "DeadTime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "LendUnit"
  end

  add_index "lends", ["ItemId", "LendName"], name: "index_Lends_on_ItemId_and_LendName", unique: true, using: :btree

end
