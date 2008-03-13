class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :store_location, :only => [:index, :sent]
  
  def index
    @messages = current_user.inbox_messages
  end
  
  def new
    @message = Message.new
    @users = User.find(:all, :order => "login ASC") - [current_user]
    if @users.empty?
      flash[:notice] = "There's nobody else to send a message to!"
      redirect_back_or_default(messages_path)
    end
  end
  
  def create
    params[:message][:from_id] = session[:user]
    @message = Message.new(params[:message])
    if @message.save
      flash[:notice] = "The message has been sent."
      redirect_back_or_default(messages_path)
    else
      flash[:notice] = "This message could not be sent."
      render :action => "new"
    end
  end
 
  def destroy
    #refactor! if if else end if end else end... this can be done so much better.
    @message = Message.find(params[:id])
    if @message.belongs_to_user(current_user.id)
      if @message.from_id == current_user.id
        @message.update_attribute("from_deleted",true)
      else
        @message.update_attribute("to_deleted",true)
      end
      @message.destroy if @message.from_deleted == @message.to_deleted
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
    @messages = current_user.outbox_messages
  end
end
