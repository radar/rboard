ActionController::Routing::Routes.draw do |map|
  map.root :controller => "forums"
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.signup 'signup', :controller => "users", :action => 'signup'
  
  map.search 'search', :controller => "search", :action => "index"
    
  map.namespace :admin do |admin|
    admin.root :controller => "index"
    
    admin.resources :categories, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put } do |category|
      category.resources :forums
      category.resources :permissions
    end
    
    admin.chronic 'chronic', :controller => 'chronic'
    admin.resources :forums, :member => { :move_up => :put, :move_down => :put, :move_to_top => :put, :move_to_bottom => :put } do |forum|
      forum.resources :permissions
    end
    
    admin.resources :groups do |group|
      group.resources :members
      group.resources :users
      # For finding the permissions for a group in regards to a single forum.
      group.resources :forums do |forum|
        forum.resources :permissions
      end
      
      group.resources :permissions
    end
    
    admin.resources :ips do |ip|
      ip.resources :topics, :only => [:index]
      ip.resources :posts, :only => [:index]
      ip.resources :users, :only => [:index]
    end
    
    admin.resources :ranks
    admin.resources :themes, :member => { :make_default => :put }
    admin.resources :users, :collection => { :ban_ip => :any, :search => :get}, :member => { :ban => :any, :ban_ip => :any, :remove_banned_ip => :post } do |user|
      user.resources :ips
    end
  end
  
  
  map.namespace :moderator do |moderator|
    moderator.root :controller => "index"
    moderator.resources :topics, :member => { :lock => :put, :sticky => :put }, :collection => { :moderate => :post, :merge => :put } do |topic|
      topic.resources :moderations
      topic.resources :posts, :member => { :split => [:get, :post] }
      topic.resources :reports
    end
    
    moderator.resources :posts do |post| 
      post.resources :moderations
      post.resources :reports
    end
    
    moderator.resources :moderations
    
    moderator.resources :reports
  end
  
  map.resources :categories do |category|
    category.resources :forums
  end
  
  map.resources :forums, :collection => { :list => :get } do |forum|
    forum.resources :topics, :member => { :lock => :put, :unlock => :put }
  end
  
  map.resources :messages, :member => { :reply => :get }, :collection => { :sent => :get }
  
  map.resources :posts, :member => { :destroy => :any } do |post|
    post.resources :edits
    post.resources :reports
  end
  
  map.resources :subscriptions
  
  map.resources :topics, :member => { :reply => :get, :unlock => :put, :lock => :put } do |topic|
    topic.resources :posts, :member => { :reply => :get }
    topic.resources :subscriptions
    topic.resources :reports
  end

  map.resources :users, :member => { :profile => :any }, :collection => { :signup => [:get, :post], :ip_is_banned => :get }
  
  # pretty pagination links
  map.connect 'forums/:forum_id/topics/:id/:page#:anchor', :controller => "topics", :action => "show"
  map.connect 'forums/:forum_id/topics/:id/:page', :controller => "topics", :action => "show"
  map.connect 'forums/:id/:page', :controller => "forums", :action => "show"
  map.connect ':controller/:action/:id'
end