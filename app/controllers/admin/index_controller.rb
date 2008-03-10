class Admin::IndexController < Admin::ApplicationController
  def index
  @posts = Post.find(:all, :limit => 5, :order => "ID DESC")
  @users = User.find(:all, :limit => 5, :order => "ID DESC")
  end
end