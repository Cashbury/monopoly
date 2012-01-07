Kazdoor::Application.routes.draw do


  get "primary_user/new"
  get "primary_user/show"

  resources :invites , :only=>[:show, :index] do
    get "share_link" , :on=>:collection
  end

  resources :like

  resources :states
  resources :countries
  resources :cities

  resources :neighborhoods

  resources :transaction_types
	devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :registrations=>"users/registrations",
    :password=>"users/passwords",
    :confirmations => "users/confirmations"
  }

	devise_scope :user do
		namespace :users do
			resources :sessions, :only => [:create, :destroy]
			resources :registrations, :only=>[:create]
      resources :passwords, :only=>[:create]
      resources :confirmations, :only=>[:update]
		end
	end
  as :user do
    match '/user/confirmation' => 'users/confirmations#update', :via => :put, :as=> :update_user_confirmation
  end
  namespace :users do
		resources :users_snaps do
			get '/qr_code/:qr_code_hash.(:format)'   ,:action=>:snap, :on =>:collection
		end
		resources :places
		resources :receipts do
      get  '/receipts-customer.:format', :action=>:list_receipts_history, :on=>:collection
      get  '/pending-receipts.:format', :action=> :index, :on=>:collection
    end
		resources :rewards do
			get '/claim.:format',:action=>:claim, :on =>:member
    end
    resources :cashiers do
      get  '/check_role.:format',:action=>:check_user_role, :on =>:collection
      get  '/business/:business_id/items.:format',:action=>:list_engagements_items, :on =>:collection
      post '/ring_up.:format', :action=>:ring_up, :on=>:collection
      get  '/receipts-merchant.:format', :action=>:list_receipts_history, :on=>:collection
    end
    resource :businesses do
			get  '/primary_place', :action=>:primary_place, :on =>:collection
			post '/primary_place',:action=>:primary_place,  :on =>:collection
			get  '/set_rewards',  :action=>:set_rewards , :on =>:collection
			get  '/open_sign/:id',  :action=>:open_sign , :on =>:collection
			post '/open_sign/:id',  :action=>:open_sign , :on =>:collection
    end
    get '/list_all_cities.:format', :action=>:list_all_cities,:controller=>:places      
	end
	

  resources :users_snaps
	resources :users_snaps do
		get '/businesses/:business_id/places/:place_id/from_date/:from_date/to_date/:to_date'   ,:action=>:index, :on =>:collection
	end
	resources :loyal_customers
	resources :loyal_customers do
		get '/businesses/:business_id/places/:place_id/from_date/:from_date/to_date/:to_date'   ,:action=>:index, :on =>:collection
	end
	resources :program_types
	resources :programs
	resources :rewards do
	  get "update_businesses/:id"   ,:action=>:update_businesses , :on =>:collection  ,:as =>"update_business"
    get "update_programs/:id"     ,:action=>:update_programs   , :on =>:collection  ,:as =>"update_programs"
    get "update_campaigns/:id"    ,:action=>:update_campaigns  , :on =>:collection  ,:as =>"update_campaigns"
    get "update_items/:id"        ,:action=>:update_items     , :on =>:collection  ,:as =>"update_items"

	end

  resources :businesses do
	  get "update_cities/:id", :action=>:update_cities, :on =>:collection, :as =>"update_cities"
	  get "update_users/:id", :action=>:update_users, :on =>:collection, :as =>"update_users"
	  get '/update_currencies/:country_id', :action=>:update_currencies, :on=> :collection, :as=>"update_currencies"
	  get "update_countries.:format",:action=>:update_countries, :on =>:collection, :as =>"update_countries"
	  get "check_primary_place/:id", :action=>:check_primary_place , :on =>:collection ,:as =>"check_primary_place"
	  get "list_campaign_transactions/:c_id", :action=> :list_campaign_transactions, :on=>:member, :as=> "list_campaign_transactions"
	  get "list_enrolled_customers/:c_id", :action=> :list_enrolled_customers, :on=>:member, :as=> "list_enrolled_customers"
	  get "list_all_enrolled_customers", :action=> :list_all_enrolled_customers, :on=> :member, :as=>"list_all_enrolled_customers"
	end
	# resources :programs do
	# 	resources :engagements, :controller => "programs/engagements" do
	#       get "stamps", :on => :collection
	#       resources :places , :only=>[:issue_code], :controller => 'programs/engagements' do
	#         get "issue_code" ,:on =>:member
	#       end
	#     end
	# end

  resources :places do
		get "/google/:reference_id" , :action =>:google,          :on=>:member,  :as =>"google"
		get "/reset_google" ,         :action =>:reset_google ,   :on=>:member
    get '/for_businessid/:id' ,   :action=>:for_businessid,   :on =>:collection, :as=>"for_businessid"
	end

	resources :users

  resources :templates

  resources :print_jobs
  resources :brands
  resources :brands do
    get "crop" ,:on =>:member
  end

  resources :qr_codes do
    get "update_businesses/:id"   ,:action=>:update_businesses , :on =>:collection ,:as =>"update_business"
    get "update_engagements/:id"  ,:action=>:update_engagements , :on =>:collection, :as =>"update_engagements"
    get "update_programs/:id"     ,:action=>:update_programs , :on =>:collection, :as =>"update_programs"
    get "update_campaigns/:id"     ,:action=>:update_campaigns, :on =>:collection, :as =>"update_campaigns"
    post "panel" , :on =>:collection
    get  "panel"  , :on =>:collection
    post "printable", :on=>:collection
  end



  resources :activities do
    post "earn", :on => :collection
    post "spend", :on => :collection
  end

  resources :categories ,:followers


  resources :accounts do
    resources :reports, :only => [:create, :show, :index]
  end

  resources :businesses do
    resources :measurement_types, :controller => "businesses/measurement_types"
    resources :items, :controller => "businesses/items"
    resources :places, :controller => "businesses/places" do
      resources :items, :controller => "businesses/places/items"
    end

    resources :programs , :controller => "businesses/programs" do
      resources :campaigns , :controller => "businesses/programs/campaigns" do
        resources :engagements,:controller => "businesses/programs/campaigns/engagements" do
          post "change_status"   ,:on =>:member
	        get "stamps", :on => :collection
        end
        resources :places , :only=>[:issue_code] do
          get "issue_code" ,:on =>:member
        end
	      resources :rewards, :controller=>"businesses/programs/campaigns/rewards" do
	        post "/crop_image",:action=>:crop_image
        end
     end
    end
    resources :rewards
    resources :campaigns,:controller => "businesses/campaigns" do
      post "/crop_image",:action=>:crop_image
    end
    resources :spend_campaigns,:controller => "businesses/spend_campaigns"

    resource :cashbox, :only => [:show, :edit, :update], :controller => "businesses/cashboxes"
  end
  resources :users_management do
    get  "update_cities/:id",:action=>:update_cities , :on =>:collection ,:as =>"update_cities"
    post "check_attribute_availability", :action=>:check_attribute_availability,:on =>:collection ,:as =>"check_attribute_availability"
    post "resend_password", :action=>:resend_password,:on =>:collection ,:as =>"resend_password"
    post "send_confirmation_email", :action=>:send_confirmation_email,:on =>:collection ,:as =>"send_confirmation_email"
    post "withdraw_account", :action=>:withdraw_account, :on=>:member, :as=>"withdraw_account"
    post "deposit_account", :action=>:deposit_account, :on=>:member, :as=>"deposit_account"
    post "redeem_rewards", :action=>:redeem_reward_for_user, :on=>:member, :as=>"redeem_rewards"
    post "make_engagement", :action=>:make_engagement, :on=>:member, :as=>"make_engagement"
    get  "transactions/business/:business_id/programs/:program_id",:action=>:list_transactions,:on =>:member ,:as =>"list_transactions"
    get  "list_campaigns/business/:business_id/programs/:program_id",:action=>:list_campaigns,:on =>:member ,:as =>"list_campaigns"
    get  "manage_user_accounts", :action=>:manage_user_accounts, :on=>:member, :as=>:manage_user_accounts
    get  "redeem_rewards", :action=>:redeem_rewards, :on=>:member, :as=>:redeem_rewards
    get  "list_engagements", :action=>:list_engagements, :on=>:member, :as=>"list_engagements"
    get  "logged_actions", :action=>:logged_actions, :on=>:member, :as=>"logged_actions"
    get  "all_qr_codes_transactions",:action=>:all_qr_codes_transactions, :on=>:member, :as=>"all_qr_codes_transactions"
    get  "view_tx_details/log/:log_id", :action=>:view_tx_details, :on=>:member, :as=>"view_tx_details"
    get  "check_txs_updates/:qr_code_id", :action=> :check_txs_updates, :on=>:member, :as=>"check_txs_updates"
    get  "transactions_report", :action=> :aggregate_transactions_report, :on=>:member, :as=>"aggregate_transactions_report"
  end
	# resources :places
	# match "/places/:long/:lat.:format"      => "places#show",:constraints => { :lat => /\d+(\.[\d]+)?/,:long=>/\d+(\.[\d]+)?/}
	#   match "/places"             						=> "places#index"
  match '/foryou'             						=> "followers#index" ,:as =>:foryou
  match '/foryourbiz'         						=> "followers#new"   , :as =>:foryourbiz
  match '/business_signup'                => "home#business_signup"
  match "/get_opening_hours.:format"      =>"places#get_opening_hours"
  match "/get_users.:format"              =>"businesses#get_users"
  match "/get_places.:format"             =>"businesses#get_places"

  match "/associatable/:id/qrcodes"       =>"qr_codes#list_all_associatable_qrcodes"

  match "/show_code/:id"                  =>"qr_codes#show_code"
  match "/update_places"                  =>"places#update_places"
  match "/auto_business"                  =>"businesses#auto_business"
  match "/check_status/:id"               =>"qr_codes#check_code_status"

  match "/code/:hash_code"                =>"qr_codes#show"
  #match "check_role/:role_id"             =>"users_management#check_role"
  match "check_role"                      =>"users_management#check_role"
  match "suspend_user/:id"                =>"users_management#suspend_user"
  match "reactivate_user/:id"             =>"users_management#reactivate_user"
  match "list_by_program_type/:program_type_id/:uid" =>"users_management#list_businesses_by_program_type"
  match "enrollments/:user_id/:pt_id/:enroll" => "users_management#manage_user_enrollments"
  match "campaign_enrollments/:user_id/:c_id/:enroll" => "users_management#manage_campaign_enrollments"
  match "reissue_code/:id"                =>"users_management#reissue_code"
  match "reissue_code_from_listing_txs/:id" =>"users_management#reissue_code_from_listing_txs"
  
  match "/users_management/update_places/:id" =>"users_management#update_places"
  match "/users/add_my_phone/:phone_number.:format" =>"users/places#add_my_phone"
  match "/users/:business_id/get_id.:format" =>"users/places#get_my_id"  



  scope "api" do
    scope "v1" do
      get "users/:id/engage/:engagement_id" => "services#engage"
    end
  end

  match "/v1/users/:column_type.:format"  =>"businesses#get_users" #pass term as query params
  match "/v1/cities/:id/vote/:like"       => "cities#vote"
  match "/v1/cities/:id/votes.:format"    => "cities#votes"
  match "/v1/cities/:name.:format"        => "cities#index"
  match "/v1/popular_cities.:format"      => "cities#popular"
  match "/v1/users/:id/:status.:format"   => "users_snaps#update_user"
  match "/v1/engagements/:id.:format"     => "businesses#get_engagement"



  #match "/v1/countries.format"               =>"countries#index"
  #match "/v1/cities/:country_id/:city_id/"  =>"cities#city_by_country"

  #match "/select_partial/:eng_type/" => "businesses/campaigns#select_partial"

  #devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  #root :to => "businesses#index"
  root :to =>"followers#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

end
