require 'sham'
require 'machinist/active_record'

this = File.expand_path(File.dirname(__FILE__))
# Order needs to be custom because topics & users need to be loaded before posts.
# We may run into a similar issue further on with other models.
["categories", "forums", "groups", "permissions", "topics", "users", "posts"].each do |file|
  require File.join(this, "../../spec/blueprints", file)
end