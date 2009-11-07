class Moderator::ApplicationController < ApplicationController
  layout "moderator"
  helper "namespaced"
  before_filter :non_moderator_redirect
  before_filter :can_not_manage

  def can_not_manage
    unless controller_name == "index"
      if !current_user.can?("manage_#{controller_name}")
        flash[:notice] = t(:not_allowed_to_manage, :area => controller_name)
        redirect_to moderator_root_path
      end
    end
  end
end