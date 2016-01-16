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

ActiveRecord::Schema.define(version: 20160116113352) do

  create_table "time_entries", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.datetime "start"
    t.datetime "end"
    t.integer  "duration"
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "slack_id"
    t.string   "slack_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
