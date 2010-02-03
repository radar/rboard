class Admin::PermissionsController < Admin::ApplicationController
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

  def create
    @permission = @object.permissions.build(params[:permission])
    if @permission.save
      flash[:notice] = t(:created, :thing => "permission")
      redirect_back_or_default [:admin, @object, :permissions]
    else
      flash[:notice] = t(:not_created, :thing => "permission")
      render :action => "new"
    end
  end

  def edit
    @permission = @object.permissions.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    permission_not_found
  end

  def update
    @permission = @object.permissions.find(params[:id])
    if @permission.update_attributes(params[:permission])
      flash[:notice] = t(:updated, :thing => "permission")
      redirect_back_or_default [:admin, @object, :permissions]
    else
      flash[:notice] = t(:not_updated, :thing => "permission")
      render :action => "edit"
    end
  rescue ActiveRecord::RecordNotFound
    permission_not_found
  end

  def destroy
    @permission = @object.permissions.find(params[:id])
    @permission.destroy
    flash[:notice] = t(:deleted, :thing => "permission")
    redirect_back_or_default [:admin, @object, :permissions]
  end
  private

  def find_group
    @object = Group.find(params[:group_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    not_found("group")
  end

  def find_forum
    @object = Forum.find(params[:forum_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    not_found("forum")
  end

  def find_category
    @object = Category.find(params[:category_id], :include => :permissions)
  rescue ActiveRecord::RecordNotFound
    not_found("category")
  end

  def not_found(object)
    flash[:notice] = t(:not_found, object)
    redirect_back_or_default admin_groups_path
  end
end
