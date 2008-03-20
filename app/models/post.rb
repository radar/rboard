class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :editor, :class_name => "User", :foreign_key => "edited_by_id"
  validates_length_of :text, :minimum => 4
  validates_presence_of :text
  
  after_create :update_forum
  after_destroy :find_latest_post
  
  def update_forum
    forum.last_post_id = id
    Post.update_latest_post(self)
  end
  
  def self.update_latest_post(post)
    post.forum.last_post_id = post.id
    if post.forum.sub? 
      for ancestor in post.forum.ancestors
        ancestor.last_post_id = post.id
        ancestor.last_post_forum_id = post.forum.id
        ancestor.save
      end
    end
    post.forum.last_post_id = post.id
    post.forum.last_post_forum_id = nil
    post.forum.save
  end
  
  def find_latest_post
    last = forum.posts.last
    if !last.nil?
      update_latest_post(last)
    else
      forum.last_post_id = nil
      forum.last_post_forum_id = nil
      forum.save
    end

  end
  
  def forum
    topic.forum
  end
end
