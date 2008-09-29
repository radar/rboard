class Admin::ChronicController < Admin::ApplicationController
  
  # Will parse any given time using Chronic and give it back.
  # Example: Inputting "Two weeks ago" will give the day two weeks ago.
  def index
    @time = Chronic.parse(params[:duration]).strftime(date_display + " " + time_display)
    render :text => @time
  end
  
end
