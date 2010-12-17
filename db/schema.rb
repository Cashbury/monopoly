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

ActiveRecord::Schema.define(:version => 20101217204424) do

  create_table "businesses", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "businesses_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "category_id"
  end

  create_table "campaigns", :force => true do |t|
    t.string    "name"
    t.string    "campaign_type"
    t.timestamp "expire_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "campaigns_places", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "campaign_id"
  end

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.integer   "parent_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "engagements", :force => true do |t|
    t.string    "engagement_type"
    t.string    "points"
    t.string    "state"
    t.string    "description"
    t.integer   "campaign_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name"
  end

  create_table "places", :force => true do |t|
    t.string    "name"
    t.string    "long"
    t.string    "lat"
    t.integer   "business_id"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "qrcodes", :force => true do |t|
    t.integer  "engagement_id"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rewards", :force => true do |t|
    t.string    "name"
    t.integer   "engagement_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                               :default => "", :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string    "password_salt",                       :default => "", :null => false
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
