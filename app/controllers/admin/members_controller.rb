class Admin::MembersController < ApplicationController
  before_filter :find_group

  def create
    @user = User.find_by_login!(params[:user])
    @group.users << @user unless @group.users.include?(@user)
    flash[:notice] = t(:has_been_placed_into, :user => @user.to_s, :group => @group.to_s)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t(:not_found, :thing => "user")
  ensure
    redirect_to admin_group_users_path(@group)
  end

  def destroy
    @user = User.find_by_login!(params[:id])
    @group.users -= [@user]
    flash[:notice] = t(:has_been_removed, :user => @user.to_s, :group => @group.to_s)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t(:not_found, :thing => "user")
  ensure
    redirect_to admin_group_users_path(@group)
  end

  private

  def find_group
    @group = Group.find(params[:group_id], :include => :users)
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = t(:not_found, :thing => "group")
    redirect_back_or_default admin_groups_path
  end
end
