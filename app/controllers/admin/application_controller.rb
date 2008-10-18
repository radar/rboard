class Admin::ApplicationController < ApplicationController
  layout "admin"
  helper "namespaced"
  before_filter :non_admin_redirect
end