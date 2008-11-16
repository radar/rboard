ActionController::Routing::Routes.draw do |map|
  map.root :controller => "forums"
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.signup 'signup', :controller => "users", :action => 'signup'
  
  map.search 'search', :controller => "search", :action => "index"
    
  map.namespace :admin do |admin|
    admin.root :controller => "index"
    admin.resources :ranks
    admin.resources :users, :collection => { :ban_ip => :any }, :member => { :ban => :any, :ban_ip => :any }
    admin.resources :themes, :member => { :make_default => :put }
    admin.resources :forums, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put }
    admin.chronic 'chronic', :controller => 'chronic'
  end
  
  map.namespace :moderator do |moderator|
    moderator.root :controller => "index"
    moderator.resources :topics, :member => { :toggle_lock => :put, :toggle_sticky => :put }, :collection => { :moderate => :post, :merge => :put } do |topic|
      topic.resources :moderations
      topic.resources :posts, :member => { :split => [:get, :post] }
    end
    
    moderator.resources :posts do |post| 
      post.resources :moderations
      post.resources :edits
    end
    
    moderator.resources :moderations
  end
  
  map.resources :forums, :collection => { :list => :get } do |forum|
    forum.resources :topics, :member => { :lock => :put, :unlock => :put }
  end
  
  map.resources :topics, :member => { :reply => :get, :unlock => :put, :lock => :put } do |topic|
    topic.resources :posts, :member => { :reply => :get }
  end
  
  map.resources :messages, :member => { :reply => :get }, :collection => { :sent => :get }
  
  map.resources :posts, :member => { :destroy => :any } do |post|
    post.resources :edits
  end
  
  map.resources :users, :member => { :profile => :any }, :collection => { :signup => [:get, :post]}
  
  # pretty pagination links
  map.connect 'forums/:forum_id/topics/:id/:page', :controller => "topics", :action => "show"
  map.connect 'forums/:id/:page', :controller => "forums", :action => "show"
  map.connect ':controller/:action/:id'
end
