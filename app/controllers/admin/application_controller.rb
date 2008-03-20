class Admin::ApplicationController < ApplicationController
  layout "admin"
  helper "admin"
  before_filter :non_admin_redirect
end