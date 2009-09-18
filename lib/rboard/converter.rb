require 'lib/rboard/basic_setup'
class PHPBB::Converter
  HOLDING_CELL = "#{RAILS_ROOT}/export"
  def self.convert
    # Remove all records.
    [User, Forum, Topic, Post, Category].map(&:delete_all)
    
    # Basic rboard scaffold
    BasicSetup.new
    
    puts "Importing PHPBB Users"
    PHPBB::User.all.each do |phpbb_user|
      User.new do |user|
        user.old_id = phpbb_user.user_id
        user.login = phpbb_user.username
        
        # HACK
        user.email = phpbb_user.user_email.blank? ? "imported-#{Time.now.to_f}@from.phpbb.local" : phpbb_user.user_email
        
        user.created_at = phpbb_user.user_regdate
        # Because password is blank, we fix this up later.
        user.save(false)
      end
    end

    puts "Importing PHPBB Forums"
    PHPBB::Forum.all.each do |phpbb_forum|
      forum = Forum.new do |forum|
        forum.old_id = phpbb_forum.forum_id
        forum.title = phpbb_forum.forum_name
        forum.description = phpbb_forum.forum_desc
        forum.save!
        forum
      end
      
      puts "Importing PHPBB Topics and Posts for #{forum}"
      phpbb_forum.topics.each do |phpbb_topic|
        Topic.new do |topic|
          topic.forum = Forum.find_by_old_id(phpbb_forum.forum_id)
          topic.old_id = phpbb_topic.topic_id
          topic.subject = phpbb_topic.topic_title
          topic.created_at = Time.at(phpbb_topic.topic_time)
          topic.user = User.find_by_old_id(phpbb_topic.topic_poster)
          phpbb_topic.posts.each do |phpbb_post|
            topic.posts.build do |post|
              post.old_id = phpbb_post.post_id
              post.created_at = Time.at(phpbb_post.post_time)
              post.user = User.find_by_old_id(phpbb_post.poster_id)
              post.text = phpbb_post.post_text
            end
          end
          topic.save!
        end
      end
    end
    puts "Done!"
  end
end
        