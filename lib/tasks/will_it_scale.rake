task(:will_it_scale => :environment) do
  require 'faker'
  levels = [1,2,3]
  100.times do |i|
    forum_attributes = { :title => Faker::Name.name, :description => Faker::Lorem.sentence, :is_visible_to => UserLevel.find(levels.rand), :topics_created_by => UserLevel.find(levels.rand) }
    forum = Forum.create(forum_attributes)
  end
end