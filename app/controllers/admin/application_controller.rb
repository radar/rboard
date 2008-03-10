class Admin::ApplicationController < ApplicationController
  layout "admin"
  helper "admin"
  before_filter :is_admin_redirect
end