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

ActiveRecord::Schema.define(:version => 20110312072810) do

  create_table "accounts", :force => true do |t|
    t.integer  "points"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
  end

  create_table "businesses_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "category_id"
  end

  create_table "businesses_places", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "campaign_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagements", :force => true do |t|
    t.string   "engagement_type"
    t.string   "points"
    t.string   "state"
    t.string   "description"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "place_id"
  end

  create_table "engagements_places", :id => false, :force => true do |t|
    t.integer "engagement_id"
    t.integer "place_id"
  end

  create_table "histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "newsletters", :force => true do |t|
    t.boolean  "letter_type"
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletters", ["email"], :name => "index_newsletters_on_email", :unique => true

  create_table "places", :force => true do |t|
    t.string   "name"
    t.decimal  "long",         :precision => 15, :scale => 10
    t.decimal  "lat",          :precision => 15, :scale => 10
    t.integer  "business_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address1"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "country"
    t.string   "distance",                                     :default => "0"
  end

  add_index "places", ["lat", "long"], :name => "index_places_on_lat_and_long"

  create_table "places_rewards", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "reward_id"
  end

  create_table "print_jobs", :force => true do |t|
    t.string   "name"
    t.integer  "ran"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display"
  end

  create_table "program_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "type_id",                       :null => false
    t.boolean  "auto_enroll"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "business_id",                   :null => false
    t.integer  "initial_points", :default => 0
    t.integer  "max_points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qr_codes", :force => true do |t|
    t.integer  "place_id"
    t.integer  "engagement_id"
    t.string   "hash_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_code"
    t.boolean  "code_type"
    t.boolean  "status"
    t.integer  "point"
    t.integer  "print_job_id"
  end

  create_table "qrcodes", :force => true do |t|
    t.integer  "engagement_id"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.integer  "engagement_id"
    t.integer  "place_id"
    t.string   "points"
    t.string   "activity_type"
    t.integer  "account_id"
  end

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.text     "description"
    t.integer  "points"
    t.integer  "claim"
    t.datetime "available"
    t.integer  "engagement_id"
    t.text     "legal_term"
    t.decimal  "price",         :precision => 10, :scale => 0
    t.string   "product_id"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "back_photo"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "front_photo"
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_snaps", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "qr_code_id", :null => false
    t.datetime "used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
