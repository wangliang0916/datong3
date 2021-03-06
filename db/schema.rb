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

ActiveRecord::Schema.define(:version => 20161220033309) do

  create_table "attachments", :force => true do |t|
    t.integer  "customer_id"
    t.string   "description"
    t.string   "file"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "pinyin"
  end

  add_index "customers", ["mobile_phone"], :name => "index_customers_on_mobile_phone", :unique => true
  add_index "customers", ["pinyin"], :name => "index_customers_on_pinyin"

  create_table "notifies", :force => true do |t|
    t.integer  "customer_id"
    t.string   "content"
    t.string   "date"
    t.string   "time"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "type"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.string   "customer_name"
    t.string   "customer_mobile_phone"
    t.string   "content"
    t.string   "notify_time"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "notify_date"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "pinyin"
  end

  add_index "users", ["mobile_phone"], :name => "index_users_on_mobile_phone", :unique => true
  add_index "users", ["pinyin"], :name => "index_users_on_pinyin"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_customers", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "customer_id"
  end

end
