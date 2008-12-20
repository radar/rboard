xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @topic.subject
    xml.description @topic.subject
    xml.link forum_url(:format => :rss)
    for post in @topic.posts.last(50)
      xml.item do
        xml.title post.subject
        xml.description post.text
        xml.pubDate post.created_at.to_s(:rfc822)
        page = (post.topic.posts.count.to_f / per_page).ceil
        xml.link forum_topic_path(post.forum, @topic, :page => page) + "#post_#{post.id}"
        xml.guid forum_topic_path(post.forum, @topic, :page => page) + "#post_#{post.id}"
      end
    end
  end
end