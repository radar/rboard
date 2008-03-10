class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :store_location, :only => [:index, :sent]
  
  def index
    #should be to_deleted?
    @messages = Message.find_all_by_to_id_and_to_deleted(current_user.id,false).reverse
  end
  
  def new
    @message = Message.new
    @users = User.find(:all, :order => "login ASC").reject! { |u| u.login == current_user.login }
  end
  
  def create
    params[:message][:from_id] = session[:user]
    @message = Message.create(params[:message])
    redirect_back_or_default(messages_path)
  end
 
  def destroy
	  #refactor! if if else end if end else end... this can be done so much better.
    @message = Message.find(params[:id])
    if @message.belongs_to_user(current_user.id)
    if @message.from_id == current_user.id
    @message.update_attribute("from_deleted",true)
    @message.update_attribute("to_deleted",true)
    end
    if @message.from_deleted == @message.to_deleted
	    @message.destroy
    end
    flash[:notice] = "This message has been deleted."
    else
	flash[:notice] = "This message does not belong to you."
end
     redirect_back_or_default(messages_path)	
  end
  
  def show
	  @message = Message.find(params[:id])
	  if !@message.belongs_to_user(current_user.id)
          flash[:notice] = "That message does not belong to you."
	 redirect_back_or_default(messages_path)
    elsif @message.to_id == current_user.id
	    @message.update_attribute("to_read",true)
    elsif @message.from_id == current_user.id
	    @message.update_attribute("from_read",true)
	    end
  end
  
  def reply
	  @message = Message.find(params[:id])
	  @users = User.find(:all, :order => "login ASC")
	end
  
  def sent
        @messages = Message.find_all_by_from_id_and_from_deleted(current_user.id,false).reverse
  end
end
