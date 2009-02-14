class Admin::ApplicationController < ApplicationController
  layout "admin"
  helper "namespaced"
  before_filter :can_access
  before_filter :can_manage
  
  private
    def can_access
      if !current_user.can?(:access_admin_section)
        flash[:notice] = t(:need_to_be_admin)
        redirect_back_or_default(root_path)
      end
    end
      
    def can_manage
      if !current_user.can?("manage_#{params[:controller]}")
        flash[:notice] = t(:not_allowed_to_manage, :area => params[:controller])
      end
    end
end