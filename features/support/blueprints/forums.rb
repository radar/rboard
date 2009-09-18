Forum.blueprint do
  title { Faker::Name.name }
  description { Faker::Company.catch_phrase }
end

Forum.blueprint(:public_forum) do
  title "Public Forum"
  category { Category.find_by_name("Public Category") || Category.make(:public) }
end
