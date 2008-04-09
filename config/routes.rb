ActionController::Routing::Routes.draw do |map|
  map.root :controller => "forums"
  map.connect 'login', :controller => 'accounts', :action => 'login'
  map.connect 'logout', :controller => 'accounts', :action => 'logout'
  map.connect 'signup', :controller => 'accounts', :action => 'signup'
  map.connect 'admin', :controller => "admin/index", :action => "index"
  map.connect 'topics/reply/:id/:quote', :controller => 'topics', :action => 'reply'
 
  map.namespace :admin do |admin|
    admin.resources :ranks
    admin.resources :accounts, :collection => { :ban_ip => :any }, :member => { :ban => :any }
    admin.resources :themes, :member => { :make_default => :put }
    admin.resources :forums, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put  }
  end
  
  #FIXME
  map.connect '/admin/chronic', :controller => "/admin/chronic"
 
  map.resources :forums, :collection => { :list => :get } do |forum|
    forum.resources :topics, :collection => { :moderate => :post } 
  end
  
  map.resources :topics, :member => { :reply => :get, :unlock => :put, :lock => :put } do |topic|
    topic.resources :posts
  end
  map.resources :messages, :member => { :reply => :get }, :collection => { :sent => :get }
  map.resources :posts
  


  map.connect ':controller/:action/:id'
  map.connect 'accounts/:page', :controller => "accounts", :action => "index"
  map.connect 'forums/:id/:page', :controller => "forums", :action => "show"

  
end
