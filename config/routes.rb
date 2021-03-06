ActionController::Routing::Routes.draw do |map|
  map.resources :feeds, :collection => {:ping => :any, :simple => :get, :create_simple => :post}

  map.resources :topics do |topic|
    topic.resources :items, :collection => {:tag_cloud => :get, :tags => :get },
      :member => {:add_tag => :put, :delete_tag => :delete, :toggle_relevant => :put }
  end
  map.resources :items, :collection => {:tag_cloud => :get, :tags => :get },
    :member => {:add_tag => :put, :delete_tag => :delete, :toggle_relevant => :put }
  map.item_tags '/tag/*tags', :controller => "items", :action => "index"  
  map.topic_tags '/topics/:topic_id/tag/*tags', :controller => "items", :action => "index"
map.formatted_item_tags '/:format/tag/*tags', :controller => "items", :action => "index"
map.formatted_topic_tags '/:format/topics/:topic_id/tag/*tags', :controller => "items", :action => "index"
  map.tags '/tags', :controller => "items", :action => "tag_cloud"


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
  map.root :controller => "topics"

  map.login '/login', :controller => 'goldberg/auth', :action => 'login'
  map.logout '/logout', :controller => 'goldberg/auth', :action => 'login'
  map.signup '/signup', :controller => 'goldberg/users', :action => 'self_register'
  map.profile '/profile', :controller => 'goldberg/users', :action => 'self_show'
  map.about '/about', :controller => 'goldberg/content_pages', :action => 'view', :page_name => ['about']
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
