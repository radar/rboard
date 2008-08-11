class SearchController < ApplicationController
  def index
    if request.post?
      @posts = Post.search params[:query]
    end
  end
end
