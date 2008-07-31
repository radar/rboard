class Admin::RanksController < Admin::ApplicationController
  before_filter :store_location, :only => [:new, :index]
  
  def index
    @ranks = Rank.find(:all)
  end

  def new
	  @rank = Rank.new
  end

  def create
	  @rank = Rank.new(params[:rank])
    if @rank.save
      flash[:notice] = "#{@rank} has been created."
      redirect_to admin_ranks_path
    else
      flash[:notice] = "This rank could not be created."
      render :action => "new"
    end
  end

  def edit
	  @rank = Rank.find(params[:id])
  end

  def update
	  @rank = Rank.find(params[:id])
	  if @rank.update_attributes(params[:rank])
		  flash[:notice] = "#{@rank} has been updated."
		  redirect_to admin_ranks_path
    else
		  flash.now[:notice] = "#{@rank} has not been updated."
		  render :action => "edit"
	  end
  end

  def destroy
	  @rank = Rank.find(params[:id]).destroy
	  flash[:notice] = "#{@rank} has been destroyed."
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "The rank you were looking for could not be found."
  ensure 
    redirect_to admin_ranks_path
  end
  
end
