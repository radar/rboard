class SearchController < ApplicationController
  def index
    if request.post?
      if SEARCHING
        @posts = Post.search(params[:search])
      else
        flash[:notice] = t(:Search_disabled)
        redirect_to root_path
      end
    end
  end
end
