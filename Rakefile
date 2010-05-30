$:.reject! { |e| e.include? 'TextMate' }

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'thinking_sphinx/tasks'

Rails::Application.load_tasks