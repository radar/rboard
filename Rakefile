$:.reject! { |e| e.include? 'TextMate' }
require File.join(File.dirname(__FILE__), 'config', 'boot.rb')
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :ar_test => :environment do
  t = Topic.new(:subject => "topic")
  p = t.posts.build
  p p.topic
end
