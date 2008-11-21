# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'factory_girl'
Cucumber::Rails.use_transactional_fixtures
Factory.define :administrator, :class => UserLevel do |u|
  u.name 'Administrator'
  u.position 3
end

Factory.define :moderator, :class => UserLevel do |u|
  u.name "Moderator"
  u.position 2
end

Factory.define :user, :class => UserLevel do |u|
  u.name "User"
  u.position 1
end

Factory.define :anne, :class => User do |u|
  u.login 'anne'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'admin@rboard.com'
  u.user_level Factory.create(:administrator)
end

Factory.define :madeline, :class => User do |u|
  u.login 'anne'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'admin@rboard.com'
  u.user_level Factory(:moderator)
end

Factory.define :bob, :class => User do |u|
  u.login 'anne'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'admin@rboard.com'
  u.user_level Factory(:user)
end

Factory.define :theme do |t|
  t.name 'blue'
  t.is_default true
end

Factory.define :admin_forum, :class => "Forum" do |f|
  f.title "Admins Only"
  f.description "This is the admin only forum"
  f.is_visible_to Factory(:administrator)
  f.topics_created_by Factory(:administrator)
end

Factory.define :moderator_forum, :class => "Forum" do |f|
  f.title "Moderators Only"
  f.description "This is the moderator only forum"
  f.is_visible_to Factory(:moderator)
  f.topics_created_by Factory(:moderator)
end

# Comment out the next line if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
