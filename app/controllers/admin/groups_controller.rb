class Admin::GroupsController < Admin::ApplicationController
  before_filter :find_group, :only => [:show, :edit, :update, :destroy]
  before_filter :find_fields, :only => [:new, :create, :edit, :update]
  
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
    @permission = @group.permissions.build
  end
  
  def create
    @group = Group.new(params[:group].merge!(:owner => current_user))
    if @group.save
      flash[:notice] = t(:group_created)
      redirect_to admin_groups_path
    else
      flash[:notice] = t(:group_not_created)
      render :action => "new"
    end
  end
  
  def edit
    @permission = @group.permissions.global
  end
  
  def update
    @permission = @group.permissions.global
    if @group.update_attributes(params[:group]) && @permission.update_attributes(params[:permission])
      flash[:notice] = t(:group_updated)
      redirect_to admin_groups_path
    else
      flash[:notice] = t(:group_not_updaed)
      render :action => "edit"
    end
  end
  
  def destroy
    @group.destroy
    flash[:notice] = t(:group_deleted)
    redirect_to admin_groups_path
  end
  
  private
  
    def find_fields
      @fields = Permission.columns.map(&:name).grep(/can/).sort
    end
  
    def find_group
      @group = Group.find(params[:id])
    rescue ActiveRecord::NotFound
      not_found
    end
    
    def not_found
      flash[:notice] = t(:group_not_found)
      redirect_to admin_groups_path
    end
end
