ActionController::Routing::Routes.draw do |map|
  map.user_calendar '/user_calendar/:user_id/:year/:month', :controller => 'user_calendar', :action => 'index', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.calendar '/calendar/:year/:month', :controller => 'calendar', :action => 'index', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot    '/forgot', :controller => 'users', :action => 'forgot'
  map.reset     '/reset/:reset_code', :controller => 'users', :action => 'reset'
  map.resources :users do |user|
    user.resources :assignments#, :collection => {:create_from_user => :post, :create_from_event => :post}
  end

  map.resource :session

  map.resources :assignments, :only => [:show, :edit, :update, :delete]

  map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }
  map.resources :unavailabilities


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.root :controller => :calendar, :action => :index, :year => Time.now.year, :month => Time.now.month

  map.resources :clients do |client|
    client.resources :events, :only => [:new, :create]
    client.resources :contacts
  end

  map.resources :events, :except => [:new, :create], :member => {:print => [:get], :send_resume => [:get]}  do |event|
    event.resources :assignments, 
      :member => {
        :accept => [:get, :put], 
        :confirm => [:get, :put], 
        :cancel => [:get, :put], 
        :deny => [:get, :put], 
        :solicitate => [:get, :put], 
        :update_state => [:put] }, 
      :collection => {
        :solicitate => :post }
  end


#  map.calendar '/calendar/:year/:month', :controller => 'calendar', :action => 'index'
  map.calendar '/calendar', :controller => 'calendar', :action => 'index'
#  map.user_calendar '/user_calendar', :controller => 'user_calendar', :action => 'index'
  map.user_calendar '/user_calendar/:id', :controller => 'user_calendar', :action => 'index'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
