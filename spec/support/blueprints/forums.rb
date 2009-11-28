Forum.blueprint do
  title { Faker::Name.name }
  description { Faker::Company.catch_phrase }
end

Forum.blueprint(:public) do
  title "Public Forum"
  category { Category.make(:public) }
end

Forum.blueprint(:sub_of_public) do
  title "Sub of Public Forum"
  parent { Forum.find_by_title("Public Forum") }
end

Forum.blueprint(:sub_of_sub_of_public) do
  title "Sub of sub of Public Forum"
  parent { Forum.find_by_title("Sub of Public Forum") }
end