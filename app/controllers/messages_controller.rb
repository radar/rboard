class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :store_location, :only => [:index, :sent]
  
  def index
    @messages = current_user.inbox_messages
  end
  
  def show
    @message = Message.find(params[:id])
    if !@message.belongs_to?(current_user.id) && !current_user.admin?
      flash[:notice] = t(:message_does_not_belong_to_you)
      redirect_back_or_default(messages_path)
    else
      @message.update_attribute("to_read",true)  if @message.to == current_user
      @message.update_attribute("from_read",true) if @message.from == current_user
    end
  end
  
  def new
    @message = current_user.outbox_messages.new
    @users = User.find(:all, :order => "login ASC") - [current_user]
    if @users.empty?
      flash[:notice] = t(:nobody_else)
      redirect_back_or_default(messages_path)
    end
  end
  
  def create
    @message = current_user.outbox_messages.new(params[:message])
    if @message.save
      flash[:notice] = t(:message_sent)
      redirect_back_or_default(messages_path)
    else
      flash[:notice] = t(:mesage_could_not_be_sent)
      render :action => "new"
    end
  end
 
  def destroy
    @message = Message.find(params[:id]) 
    if @message.belongs_to?(current_user.id) && !current_user.admin?
      @message.update_attribute("#{@message.from_id == current_user.id ? "from" : "to"}_deleted",true) 
      @message.destroy if @message.from_deleted == @message.to_deleted
      flash[:notice] = t(:message_deleted)
    else
      flash[:notice] = t(:message_does_not_belong_to_you)
    end
    redirect_back_or_default(messages_path)	
  end
  
  def reply
    @message = Message.find(params[:id])
    @users = User.find(:all, :order => "login ASC")
  end
  
  def sent
    @messages = current_user.outbox_messages
  end
end
