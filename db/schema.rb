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

ActiveRecord::Schema.define(:version => 20110414123418) do

  create_table "account_holders", :force => true do |t|
    t.string   "model_type"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_holder_id"
    t.integer  "campaign_id"
    t.integer  "measurement_type_id"
    t.decimal  "amount",              :precision => 20, :scale => 3
    t.boolean  "is_money"
  end

  create_table "amenities", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "amenities_places", :id => false, :force => true do |t|
    t.integer  "amenity_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
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

  create_table "campaigns", :force => true do |t|
    t.string   "name",                               :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "initial_points",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.integer  "measurement_type_id"
  end

  create_table "campaigns_targets", :id => false, :force => true do |t|
    t.integer  "target_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "employee_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "position"
    t.integer  "employee_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagements", :force => true do |t|
    t.boolean  "state",                                             :default => true
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.decimal  "amount",             :precision => 20, :scale => 3
    t.integer  "campaign_id"
    t.integer  "engagement_type_id"
  end

  create_table "engagements_places", :id => false, :force => true do |t|
    t.integer "engagement_id"
    t.integer "place_id"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",       :precision => 10, :scale => 3
    t.integer  "business_id"
    t.string   "photo"
    t.boolean  "available"
    t.date     "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items_places", :id => false, :force => true do |t|
    t.integer  "place_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items_rewards", :id => false, :force => true do |t|
    t.integer  "reward_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legal_ids", :force => true do |t|
    t.integer  "id_number"
    t.integer  "legal_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legal_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_groups", :force => true do |t|
    t.date     "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "reward_id"
    t.string   "log_type"
    t.boolean  "is_processed"
    t.integer  "place_id"
    t.integer  "engagement_id"
    t.integer  "business_id"
    t.decimal  "lat",           :precision => 15, :scale => 10
    t.decimal  "lng",           :precision => 15, :scale => 10
    t.string   "currency"
    t.decimal  "amount",        :precision => 20, :scale => 3
    t.integer  "frequency"
    t.string   "amount_type"
    t.date     "created_on"
    t.integer  "log_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "open_hours", :force => true do |t|
    t.integer  "day_no"
    t.datetime "from"
    t.datetime "to"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "program_type_id"
    t.integer  "business_id"
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
    t.boolean  "exported",      :default => false
    t.integer  "related_id"
    t.string   "related_type"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.decimal  "needed_amount", :precision => 10, :scale => 0
    t.integer  "claim"
    t.datetime "available"
    t.text     "legal_term"
    t.integer  "campaign_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "targets", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "targets_users", :id => false, :force => true do |t|
    t.integer  "target_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "title"
    t.string   "tag"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "from_account"
    t.integer  "to_account"
    t.decimal  "amount",       :precision => 20, :scale => 3
    t.string   "account_type"
    t.boolean  "is_money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_actions", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "qr_code_id"
    t.integer  "business_id"
    t.integer  "reward_id"
    t.date     "used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

  add_index "user_actions", ["business_id"], :name => "index_user_actions_on_business_id"
  add_index "user_actions", ["qr_code_id"], :name => "index_user_actions_on_qr_code_id"
  add_index "user_actions", ["reward_id"], :name => "index_user_actions_on_reward_id"
  add_index "user_actions", ["user_id"], :name => "index_user_actions_on_user_id"

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
    t.boolean  "admin"
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
