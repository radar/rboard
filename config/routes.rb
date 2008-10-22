ActionController::Routing::Routes.draw do |map|
  map.root :controller => "forums"
  map.login 'login', :controller => 'accounts', :action => 'login'
  map.logout 'logout', :controller => 'accounts', :action => 'logout'
  map.signup 'signup', :controller => "accounts", :action => 'signup'
  
  map.search 'search', :controller => "search", :action => "index"
  map.admin 'admin', :controller => "admin/index", :action => "index"
  map.moderator 'moderator', :controller => "moderator/index", :action => "index"
  map.connect 'topics/reply/:id/:quote', :controller => 'topics', :action => 'reply'
  
  map.namespace :admin do |admin|
    admin.resources :ranks
    admin.resources :accounts, :collection => { :ban_ip => :any }, :member => { :ban => :any, :ban_ip => :any }
    admin.resources :themes, :member => { :make_default => :put }
    admin.resources :forums, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put  }
    admin.chronic 'chronic', :controller => 'chronic'
  end
  
  map.namespace :moderator do |moderator|
    moderator.resources :topics, :member => { :toggle_lock => :put, :toggle_sticky => :put }, :collection => { :moderate => :post } do |topic|
      topic.resources :moderations
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
    topic.resources :posts
  end
  
  map.resources :messages, :member => { :reply => :get }, :collection => { :sent => :get }
  
  map.resources :posts, :member => { :destroy => :any } do |post|
    post.resources :edits
  end
  
  # pretty pagination links
  map.connect 'forums/:forum_id/topics/:id/:page', :controller => "topics", :action => "show"
  map.connect 'forums/:id/:page', :controller => "forums", :action => "show"
  map.resources :accounts, :collection => { :profile => :any }
  map.connect ':controller/:action/:id'
end
