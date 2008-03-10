class Admin::ChronicController < Admin::ApplicationController
  def index
    @time = Chronic.parse(params[:duration]).strftime(current_user.time_display)
    render :text => @time
    rescue Exception => e
    render :text => "Invalid format."
  end
end
