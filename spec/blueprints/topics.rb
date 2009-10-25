Topic.blueprint do
  subject Faker::Lorem.sentence
end

Topic.blueprint(:public_open) do
  forum { Forum.find_by_title("Public Forum") || Forum.make(:public) }
end