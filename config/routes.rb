ActionController::Routing::Routes.draw do |map|
  map.root :controller => "forums"
  map.login 'login', :controller => 'accounts', :action => 'login'
  map.logout 'logout', :controller => 'accounts', :action => 'logout'
  map.signup 'signup', :controller => "accounts", :action => 'signup'
  map.admin_index 'admin/index', :controller => "admin/index", :action => "index"
  map.connect 'topics/reply/:id/:quote', :controller => 'topics', :action => 'reply'
 
  map.namespace :admin do |admin|
    admin.resources :ranks
    admin.resources :accounts, :collection => { :ban_ip => :any }, :member => { :ban => :any, :ban_ip => :any }
    admin.resources :themes, :member => { :make_default => :put }
    admin.resources :forums, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put  }
  end
  
  #FIXME
  map.connect '/admin/chronic', :controller => "/admin/chronic"
 
  map.resources :forums, :collection => { :list => :get } do |forum|
    forum.resources :topics, :collection => { :moderate => :post }, :member => { :lock => :put, :unlock => :put }
  end
  
  map.resources :topics, :member => { :reply => :get, :unlock => :put, :lock => :put } do |topic|
    topic.resources :posts
  end
  map.resources :messages, :member => { :reply => :get }, :collection => { :sent => :get }
  map.resources :posts
  
  map.resources :accounts, :collection => { :profile => :any }
  
  map.connect ':controller/:action/:id'
end
