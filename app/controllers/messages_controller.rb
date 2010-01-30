class MessagesController < ApplicationController
  before_filter :login_required 
  before_filter :can_read_messages?
  before_filter :store_location, :only => [:index, :sent]
  before_filter :find_message, :only => [:show, :reply, :destroy]

  # Show messages for the currently logged in user.
  def index
    @messages = current_user.inbox_messages
  end

  # Show a particular message for the currently logged in user
  def show
    if @message.belongs_to?(current_user)
      @message.update_attribute("to_read",true)  if @message.to == current_user
      @message.update_attribute("from_read",true) if @message.from == current_user
    end
  end

  def new
    @message = current_user.outbox_messages.new
    @users = User.all(:order => "login ASC") - [current_user, User.anonymous]
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
      flash[:notice] = t(:message_not_sent)
      render :action => "new"
    end
  end

  def destroy
    # Because people with can_read_other_private_messages == true can delete messages too.
    from_or_to = if @message.from == current_user
      "from"
    elsif @message.to == current_user
      "to"
    end
    @message.update_attribute("#{from_or_to}_deleted",true) if from_or_to
    @message.destroy if @message.from_deleted == @message.to_deleted
    flash[:notice] = t(:deleted, :thing => "message")
    redirect_back_or_default(messages_path)	
  end

  def reply
    @users = User.find(:all, :order => "login ASC")
  end

  def sent
    @messages = current_user.outbox_messages
  end

  private
    def can_read_messages?
      if !current_user.can?(:read_private_messages)
        flash[:notice] = t(:you_are_not_allowed_to_read_messages)
        redirect_to root_path
      end
    end

    def find_message
      @message = Message.find(params[:id])
      if !@message.belongs_to?(current_user) && !current_user.can?(:read_others_private_messages)
        flash[:notice] = t(:message_does_not_belong_to_you)
        redirect_back_or_default(messages_path)
      end
    end
end
