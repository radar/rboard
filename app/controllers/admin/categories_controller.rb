class Admin::CategoriesController < Admin::ApplicationController
  before_filter :store_location, :only => [:index, :show]
  before_filter :find_category, :except => [:index, :new, :create]
  
   def index
     @categories = Category.all(:order => "name asc")
   end
   
   def show
     @forums = @category.forums
   end
   
   def new
     @category = Category.new   
   end
   
   def create
     @category = Category.new(params[:category])
     if @category.save
       flash[:notice] = t(:category_created)
       redirect_to admin_categories_path
     else
       flash[:notice] = t(:category_not_created)
       render :action => "new"
     end
   end
   
   def update
     if @category.update_attributes(params[:category])
       flash[:notice] = t(:category_updated)
       redirect_to admin_categories_path
     else
       flash[:notice] = t(:category_not_updated)
       render :action => "edit"
     end
   end
   
   def destroy
     @category.destroy
     flash[:notice] = t(:category_deleted)
   end
   
   # Moves a category one space up using an acts_as_list provided method.
    def move_up
      @category.move_higher
      flash[:notice] = t(:category_moved_higher, :category => @category)
      redirect
    end

   # Moves a category one space down using an acts_as_list provided method.
   def move_down
     @category.move_lower
     flash[:notice] = t(:category_moved_lower, :category => @category)
     redirect
   end

   # Moves a category to the top using an acts_as_list provided method.
   def move_to_top
     @category.move_to_top
     flash[:notice] = t(:category_moved_to_top, :category => @category)
     redirect
   end

   # Moves a category to the bottom using an acts_as_list helper.
   def move_to_bottom
     @category.move_to_bottom
     flash[:notice] = t(:category_moved_to_bottom, :category => @category)
     redirect
   end
   
   private
     def find_category
       @category = Category.find(params[:id], :include => :forums)
     end
     
     def redirect
       redirect_to admin_categories_path
     end
  
end
