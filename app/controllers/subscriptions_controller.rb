class SubscriptionsController < ApplicationController
  before_filter :find_topic, :only => [:create]
  before_filter :login_required
  before_filter :can_not_subscribe?
  before_filter :store_location, :only => [:index]

  def index
    @subscriptions = current_user.subscriptions.all(:joins => :topic, :order => "updated_at DESC")
  end

  def create
    @topic.subscriptions.create(:user => current_user)
    flash[:notice] = t(:topic_subscription)
    redirect_to([@topic.forum, @topic])
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.destroy
    flash[:notice] = t(:topic_unsubscription)
    redirect_back_or_default([subscription.topic.forum, subscription.topic])
  end


  private

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def can_not_subscribe?
    if !current_user.can?(:subscribe, @forum)
      flash[:notice] = t(:Unable_to_subscribe)
      redirect_back_or_default root_path
    end
  end
end
