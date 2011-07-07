Kazdoor::Application.routes.draw do


  get "primary_user/new"
  get "primary_user/show"

  resources :transaction_types
	devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :registrations=>"users/registrations",
    :password=>"users/passwords",
  }

	devise_scope :user do
		namespace :users do
			resources :sessions, :only => [:create, :destroy]
			resources :registrations, :only=>[:create]
      resources :passwords, :only=>[:create]
		end
	end

	namespace :users do
		resources :users_snaps do
			get '/qr_code/:qr_code_hash.(:format)'   ,:action=>:snap, :on =>:collection
		end
		resources :places
		resources :rewards do
			get '/claim.:format',:action=>:claim, :on =>:member
    end

    resource :businesses do
			get '/primary_place', :action=>:primary_place,  :on =>:collection
			post '/primary_place',:action=>:primary_place,  :on =>:collection
			get '/set_rewards',   :action=>:set_rewards ,   :on =>:collection
			get '/open_sign/:id',     :action=>:open_sign ,     :on =>:collection
			post '/open_sign/:id',    :action=>:open_sign ,     :on =>:collection
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
	  get "update_cities/:id",:action=>:update_cities,    :on =>:collection, :as =>"update_cities"
	  get "update_users/:id",:action=>:update_users,    :on =>:collection, :as =>"update_users"
	  get "update_countries.:format",:action=>:update_countries, :on =>:collection, :as =>"update_countries"
	  get "check_primary_place/:id", :action=>:check_primary_place , :on =>:collection ,:as =>"check_primary_place"
	end
	# resources :programs do
	# 	resources :engagements, :controller => "programs/engagements" do
	#       get "stamps", :on => :collection
	#       resources :places , :only=>[:issue_code], :controller => 'programs/engagements' do
	#         get "issue_code" ,:on =>:member
	#       end
	#     end
	# end
	resources :places
	resources :places do
		get '/for_businessid/:id' ,:action=>:for_businessid, :on =>:collection
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
  end

	# resources :places
	# match "/places/:long/:lat.:format"      => "places#show",:constraints => { :lat => /\d+(\.[\d]+)?/,:long=>/\d+(\.[\d]+)?/}
	#   match "/places"             						=> "places#index"
  match '/foryou'             						=> "followers#index" ,:as =>:foryou
  match '/foryourbiz'         						=> "followers#new"   , :as =>:foryourbiz
  match '/business_signup'                => "home#business_signup"
  match "/get_opening_hours.:format"      =>"places#get_opening_hours"
  match "/get_users.:format"              =>"businesses#get_users"
  match "/associatable/:id/qrcodes"       =>"qr_codes#list_all_associatable_qrcodes"  

  match "/show_code/:id"                  =>"qr_codes#show_code"
  match "/update_places"                 =>"places#update_places"
  match "/auto_business"                 =>"businesses#auto_business"
  match "/check_status/:id"               =>"qr_codes#check_code_status"
  match "/code/:hash_code"                =>"qr_codes#show"

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
