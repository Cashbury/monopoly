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

ActiveRecord::Schema.define(:version => 20110422140619) do

  create_table "account_holders", :force => true do |t|
    t.string   "model_type"
    t.integer  "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_holders", ["model_type", "model_id"], :name => "index_account_holders_on_model_type_and_model_id"

  create_table "account_types", :force => true do |t|
    t.string   "name"
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
    t.boolean  "is_external"
  end

  add_index "accounts", ["account_holder_id"], :name => "index_accounts_on_account_holder_id"
  add_index "accounts", ["campaign_id"], :name => "index_accounts_on_campaign_id"

  create_table "addresses", :force => true do |t|
    t.string   "country"
    t.string   "city"
    t.string   "zipcode"
    t.string   "neighborhood"
    t.string   "street_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "amenities_places", :id => false, :force => true do |t|
    t.integer "amenity_id"
    t.integer "place_id"
  end

  create_table "announcement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.integer  "announcement_type_id"
    t.string   "channel_type"
    t.integer  "business_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "businesses", ["brand_id"], :name => "index_businesses_on_brand_id"

  create_table "businesses_categories", :id => false, :force => true do |t|
    t.integer "business_id"
    t.integer "category_id"
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name",                               :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "initial_amount",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.integer  "measurement_type_id"
    t.string   "state"
  end

  add_index "campaigns", ["measurement_type_id"], :name => "index_campaigns_on_measurement_type_id"
  add_index "campaigns", ["program_id"], :name => "index_campaigns_on_program_id"

  create_table "campaigns_places", :id => false, :force => true do |t|
    t.integer "campaign_id"
    t.integer "place_id"
  end

  create_table "campaigns_targets", :id => false, :force => true do |t|
    t.integer "target_id"
    t.integer "campaign_id"
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
    t.string   "server"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "employee_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "position"
    t.integer  "employee_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "engagement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engagements", :force => true do |t|
    t.boolean  "is_started",                                        :default => true
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.decimal  "amount",             :precision => 20, :scale => 3
    t.integer  "campaign_id"
    t.integer  "engagement_type_id"
  end

  add_index "engagements", ["campaign_id"], :name => "index_engagements_on_campaign_id"
  add_index "engagements", ["engagement_type_id"], :name => "index_engagements_on_engagement_type_id"
  add_index "engagements", ["is_started"], :name => "index_engagements_on_is_started"

  create_table "followers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.string   "user_email"
    t.string   "user_phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "upload_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "from_user_id"
    t.string   "to_email"
    t.string   "to_phone_number"
    t.boolean  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["to_email"], :name => "index_invitations_on_to_email"
  add_index "invitations", ["to_phone_number"], :name => "index_invitations_on_to_phone_number"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",        :precision => 10, :scale => 3
    t.integer  "business_id"
    t.string   "photo"
    t.boolean  "available"
    t.date     "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_code"
    t.decimal  "cost",         :precision => 20, :scale => 3
  end

  create_table "items_places", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "item_id"
  end

  create_table "items_rewards", :id => false, :force => true do |t|
    t.integer "reward_id"
    t.integer "item_id"
  end

  create_table "legal_ids", :force => true do |t|
    t.integer  "id_number"
    t.integer  "legal_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
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
    t.decimal  "lat",            :precision => 15, :scale => 10
    t.decimal  "lng",            :precision => 15, :scale => 10
    t.string   "currency"
    t.decimal  "gained_amount",  :precision => 20, :scale => 3
    t.decimal  "frequency",      :precision => 20, :scale => 3
    t.string   "amount_type"
    t.date     "created_on"
    t.integer  "log_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
  end

  add_index "logs", ["created_at"], :name => "index_logs_on_created_at"
  add_index "logs", ["created_on"], :name => "index_logs_on_created_on"
  add_index "logs", ["engagement_id"], :name => "index_logs_on_engagement_id"
  add_index "logs", ["log_type"], :name => "index_logs_on_log_type"
  add_index "logs", ["user_id", "reward_id", "log_type"], :name => "index_logs_on_user_id_and_reward_id_and_log_type"
  add_index "logs", ["user_id"], :name => "index_logs_on_user_id"

  create_table "measurement_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "business_id"
  end

  add_index "measurement_types", ["business_id"], :name => "index_measurement_types_on_business_id"

  create_table "open_hours", :force => true do |t|
    t.integer  "day_no"
    t.datetime "from"
    t.datetime "to"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "place_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.decimal  "long",            :precision => 15, :scale => 10
    t.decimal  "lat",             :precision => 15, :scale => 10
    t.integer  "business_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_type_id"
    t.boolean  "is_user_defined"
    t.string   "street_address"
    t.integer  "address_id"
  end

  add_index "places", ["business_id"], :name => "index_places_on_business_id"
  add_index "places", ["lat", "long"], :name => "index_places_on_lat_and_long"
  add_index "places", ["name"], :name => "index_places_on_name"
  add_index "places", ["place_type_id"], :name => "index_places_on_place_type_id"

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
    t.string   "name"
    t.boolean  "is_started"
  end

  add_index "programs", ["business_id"], :name => "index_programs_on_business_id"
  add_index "programs", ["program_type_id"], :name => "index_programs_on_program_type_id"

  create_table "qr_codes", :force => true do |t|
    t.string   "hash_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "code_type"
    t.boolean  "status"
    t.boolean  "exported",          :default => false
    t.integer  "associatable_id"
    t.string   "associatable_type"
  end

  add_index "qr_codes", ["hash_code"], :name => "index_qr_codes_on_hash_code"

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.decimal  "needed_amount",      :precision => 10, :scale => 0
    t.integer  "max_claim"
    t.datetime "expiry_date"
    t.text     "legal_term"
    t.integer  "campaign_id"
    t.integer  "max_claim_per_user"
    t.boolean  "is_active"
  end

  add_index "rewards", ["campaign_id"], :name => "index_rewards_on_campaign_id"

  create_table "rewards_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "reward_id"
  end

  add_index "rewards_users", ["reward_id"], :name => "index_rewards_users_on_reward_id"
  add_index "rewards_users", ["user_id"], :name => "index_rewards_users_on_user_id"

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
    t.integer "target_id"
    t.integer "user_id"
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

  create_table "transaction_types", :force => true do |t|
    t.string   "name"
    t.decimal  "fee_amount",     :precision => 20, :scale => 3
    t.decimal  "fee_percentage", :precision => 20, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "from_account"
    t.integer  "to_account"
    t.decimal  "amount",                      :precision => 20, :scale => 3
    t.string   "account_type"
    t.boolean  "is_money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "from_account_balance_before", :precision => 20, :scale => 3
    t.decimal  "from_account_balance_after",  :precision => 20, :scale => 3
    t.decimal  "to_account_balance_before",   :precision => 20, :scale => 3
    t.decimal  "to_account_balance_after",    :precision => 20, :scale => 3
    t.string   "currency"
    t.text     "note"
    t.integer  "transaction_type_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "password_salt",                         :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.boolean  "admin"
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "last_name"
    t.string   "telephone_number"
    t.string   "username"
    t.integer  "mailing_address_id"
    t.integer  "billing_address_id"
    t.boolean  "is_fb_account"
    t.text     "note"
    t.string   "home_town"
    t.string   "language_of_preference"
    t.string   "default_currency"
    t.string   "timezone"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_referrals", :force => true do |t|
    t.integer "referrer_id"
    t.integer "referred_id"
  end

  add_index "users_referrals", ["referred_id"], :name => "index_users_referrals_on_referred_id"
  add_index "users_referrals", ["referrer_id"], :name => "index_users_referrals_on_referrer_id"

end
