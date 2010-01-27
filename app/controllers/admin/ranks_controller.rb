class Admin::RanksController < Admin::ApplicationController
  before_filter :store_location, :only => [:new, :index]
  before_filter :find_rank, :except => [:index, :new, :create]

  # Show all the ranks, in no particular order.
  def index
    @ranks = Rank.all
  end

  # Initializes a new rank.
  def new
	  @rank = Rank.new
  end

  # Creates a new rank.
  def create
	  @rank = Rank.new(params[:rank])
    if @rank.save
      flash[:notice] = t(:created, :thing => "Rank")
      redirect_to admin_ranks_path
    else
      flash[:notice] = t(:not_created, :thing => "Rank")
      render :action => "new"
    end
  end

  # Edits a rank.
  def edit
  end

  # Updates a rank.
  def update
	  if @rank.update_attributes(params[:rank])
		  flash[:notice] = t(:updated, :thing => "Rank")
		  redirect_to admin_ranks_path
    else
		  flash[:notice] = t(:not_updated, :thing => "Rank")
		  render :action => "edit"
	  end
  end

  # Deletes a rank.
  def destroy
	  @rank.destroy
	  flash[:notice] = t(:deleted, :thing => "Rank")
    redirect_to admin_ranks_path
  end

  private
    # Will be called from #find_rank when a rank cannot be found.
    def not_found
      flash[:notice] = t(:not_found, :thing => "Rank")
      redirect_back_or_default(admin_ranks_path)
    end

    def find_rank
      @rank = Rank.find(params[:id]) unless params[:id].nil?
    rescue ActiveRecord::RecordNotFound
      not_found
    end

end
