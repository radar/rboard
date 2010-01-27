class Admin::CategoriesController < Admin::ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :find_category, :except => [:index, :new, :create]

   # Find all the categories in order by name.
   def index
     @categories = Category.all
   end

   # Find all the forums for the category in question.
   def show
     @forums = @category.forums
   end

   # Initialize a new category.
   def new
     @category = Category.new   
   end

   # Create the new category.
   def create
     @category = Category.new(params[:category])
     if @category.save
       flash[:notice] = t(:created, :thing => "Category")
       redirect_to admin_categories_path
     else
       flash[:notice] = t(:not_created, :thing => "category")
       render :action => "new"
     end
   end

   # Placeholder for anything useful to do with editing categories.
   def edit
   end

   # Updates a category.
   def update
     if @category.update_attributes(params[:category])
       flash[:notice] = t(:updated, :thing => "category")
       redirect_to admin_categories_path
     else
       flash[:notice] = t(:not_updated, :thing => "category")
       render :action => "edit"
     end
   end

   # Destroys a category.
   def destroy
     @category.destroy
     flash[:notice] = t(:deleted, :thing => "category")
     redirect
   end

   # Moves a category one space up using an acts_as_list provided method.
    def move_up
      @category.move_higher
      flash[:notice] = t(:moved_higher, :thing => "Category")
      redirect
    end

   # Moves a category one space down using an acts_as_list provided method.
   def move_down
     @category.move_lower
     flash[:notice] = t(:moved_lower, :thing => "Category")
     redirect
   end

   # Moves a category to the top using an acts_as_list provided method.
   def move_to_top
     @category.move_to_top
     flash[:notice] = t(:moved_to_top, :thing => "Category")
     redirect
   end

   # Moves a category to the bottom using an acts_as_list helper.
   def move_to_bottom
     @category.move_to_bottom
     flash[:notice] = t(:moved_to_bottom, :thing => "Category")
     redirect
   end

   private

     # Finds a category
     def find_category
       @category = Category.find(params[:id], :include => :forums)
     end

     # Method added for the sake of laziness
     def redirect
       redirect_to admin_categories_path
     end

end
