class Admin::RanksController < Admin::ApplicationController
  before_filter :store_location, :only => [:new, :index]
  before_filter :find_rank, :except => [:index, :new, :create]
  
  # Show all the ranks, in no particular order.
  def index
    @ranks = Rank.find(:all)
  end

  # Initializes a new rank.
  def new
	  @rank = Rank.new
  end

  # Creates a new rank.
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
  
  # Edits a rank.
  def edit
  end
  
  # Updates a rank.
  def update
	  if @rank.update_attributes(params[:rank])
		  flash[:notice] = "#{@rank} has been updated."
		  redirect_to admin_ranks_path
    else
		  flash.now[:notice] = "#{@rank} has not been updated."
		  render :action => "edit"
	  end
  end

  # Deletes a rank.
  def destroy
	  @rank.destroy
	  flash[:notice] = "#{@rank} has been destroyed."
    redirect_to admin_ranks_path
  end
  
  private
    # Will be called from #find_rank when a rank cannot be found.
    def not_found
      flash[:notice] = "The rank you were looking for could not be found."
      redirect_back_or_default(admins_rank_path)
    end
    
    def find_rank
      @rank = Rank.find(params[:id]) unless params[:id].nil?
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  
end
