Forum.blueprint do
  title { Faker::Name.name }
  description { Faker::Company.catch_phrase }
end

Forum.blueprint(:public) do
  title "Public Forum"
  category { Category.make(:public) }
end
