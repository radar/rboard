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

Factory.define :admin, :class => User do |u|
  u.login 'admin'
  u.password 'password'
  u.password_confirmation 'password'
  u.email 'admin@rboard.com'
  u.user_level Factory(:administrator)
end

Factory.define :theme do |t|
  t.name 'blue'
  t.is_default true
end


# Comment out the next line if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
