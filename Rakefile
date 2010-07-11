$:.reject! { |e| e.include? 'TextMate' }
require File.join(File.dirname(__FILE__), 'config', 'boot.rb')
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'thinking_sphinx/tasks'
rescue LoadError
end