class SearchController < ApplicationController
  def index
    if request.post?
      @posts = Post.search(params[:query]).select { |post| post.forum.viewable?(current_user) }
    end
  end
end
