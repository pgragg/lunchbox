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

ActiveRecord::Schema.define(version: 20150818152300) do

  create_table "bagels", force: :cascade do |t|
    t.string   "bagel_filling"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "children", force: :cascade do |t|
    t.string   "grade"
    t.string   "campus"
    t.integer  "menu_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.string   "role"
  end

  create_table "children_lunches", id: false, force: :cascade do |t|
    t.integer "lunch_id"
    t.integer "child_id",    null: false
    t.integer "children_id"
  end

  add_index "children_lunches", ["children_id"], name: "index_children_lunches_on_children_id"
  add_index "children_lunches", ["lunch_id"], name: "index_children_lunches_on_lunch_id"

  create_table "daily_lunches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.boolean  "vegetarian"
    t.boolean  "smart"
    t.string   "lunch_type"
  end

  create_table "days", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "date"
  end

  create_table "holidays", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "year_id"
    t.string   "name"
  end

  create_table "lunch_choices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "day_id"
    t.integer  "lunch_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "date"
    t.integer  "child_id"
    t.string   "drink"
    t.string   "bagel_filling"
  end

  add_index "lunch_choices", ["child_id"], name: "index_lunch_choices_on_child_id"
  add_index "lunch_choices", ["day_id"], name: "index_lunch_choices_on_day_id"
  add_index "lunch_choices", ["lunch_id"], name: "index_lunch_choices_on_lunch_id"
  add_index "lunch_choices", ["user_id"], name: "index_lunch_choices_on_user_id"

  create_table "lunches", force: :cascade do |t|
    t.date     "date"
    t.string   "name"
    t.string   "description"
    t.boolean  "vegetarian"
    t.boolean  "smart"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "menu_id"
    t.string   "lunch_type"
  end

  create_table "lunches_users", id: false, force: :cascade do |t|
    t.integer "lunch_id"
    t.integer "user_id"
  end

  add_index "lunches_users", ["lunch_id"], name: "index_lunches_users_on_lunch_id"
  add_index "lunches_users", ["user_id"], name: "index_lunches_users_on_user_id"

  create_table "matches", force: :cascade do |t|
    t.boolean  "dismissed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "id1"
    t.integer  "id2"
    t.integer  "amount"
    t.integer  "child_id"
  end

  create_table "menus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "summaries", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "trimesters", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "number"
    t.integer  "year_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "menu_id"
    t.string   "campus"
    t.string   "grade"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "years", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

end
