class Admin::ChronicController < Admin::ApplicationController
  def index
    @time = Chronic.parse(params[:duration]).strftime(date_display + " " + time_display)
    render :text => @time
    rescue Exception => e
    render :text => "Invalid format."
  end
end
