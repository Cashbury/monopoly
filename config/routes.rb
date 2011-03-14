Kazdoor::Application.routes.draw do
	
    
	devise_for :users, :controllers => { :sessions => "users/sessions" }
	devise_scope :user do
    namespace :users do
      resources :sessions, :only => [:create, :destroy]  
  	end
	end
	
	namespace :admin do
		resources :users_snaps do
			match '/users_snaps/businesses/:business_id/places/:place_id/start_date/:start_date/end_date/:end_date', :to=>:index
		end 
	end
  	
	resources :users

	match '/login.(:format)' => "users_sessions#login" #this route is for quick testing fb connect and should be disabled later

	match '/users_snaps/:user_id/:qr_code_id/:used_at'=>"users_snaps#snap"
	match '/places/for_businessid/:id' =>"places#for_businessid"
	#match '/users_snaps/businesses/:business_id/places/:place_id/start_date/:start_date/end_date/:end_date' =>"users_snaps#index"
  resources :templates

  resources :print_jobs


  resources :program_types

  resources :programs

  resources :brands

  resources :newsletters
  resources :qr_codes do
    get "update_businesses/:id"   ,:action=>:update_businesses , :on =>:collection ,:as =>"update_business"
    get "update_engagements/:id"  ,:action=>:update_engagements , :on =>:collection, :as =>"update_engagements"
    post "panel" , :on =>:collection 
    get "panel"  , :on =>:collection 
    post "printable", :on=>:collection
  end

  resources :activities do
    post "earn", :on => :collection
    post "spend", :on => :collection
  end
  
  resources :categories ,:newsletters

  
  resources :accounts do
    resources :reports, :only => [:create, :show, :index]
  end
  
  resources :businesses do
    resources :places, :controller => "businesses/places" do
      resources :reports, :only => [:create, :show, :index]
    end
    resources :reports, :only => [:create, :show, :index]
    resources :engagements, :controller => "businesses/engagements" do
      get "stamps", :on => :collection
      resources :places , :only=>[:issue_code], :controller => 'businesses/engagements' do 
        get "issue_code" ,:on =>:member
      end
    end
    resources :rewards
  end
  
	resources :places
	match "/places/:long/:lat.:format"      => "places#show",:constraints => { :lat => /\d+(\.[\d]+)?/,:long=>/\d+(\.[\d]+)?/}
  match "/places"             						=> "places#index"
  match "/engagements/:id"    						=> "engagements#display"
  match "/engagements/:id/change_status"   => "engagements#change_status"
  match '/foryou'             						=> "newsletters#index" ,:as =>:foryou
  match '/foryourbiz'         						=> "newsletters#new"   , :as =>:foryourbiz
  
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
  root :to =>"newsletters#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
