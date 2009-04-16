class Admin::PermissionsController < ApplicationController
  before_filter :find_group
  before_filter :store_location, :only => :index
  
  def index
    @permissions = @object.permissions
    @category_count = Category.count
    @forum_count = Forum.count
  end
  
  def new
    @permission = @object.permissions.build
    case params[:type]
    when "category"
      @categories = Category.all
    when "forum"
      @forums = Forum.all
    end
  end
  
  private
  
  def find_group
    @object = Group.find(params[:group_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    group_not_found
  end
  
  def find_forum
    @object = Forum.find(params[:forum_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    forum_not_found
  end
  
  def find_category
    @object = Category.find(params[:category_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    category_not_found
  end
end
