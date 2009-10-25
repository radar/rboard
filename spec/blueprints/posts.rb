Post.blueprint do
end

Post.blueprint(:public_open) do
  text Faker::Lorem.paragraphs.join("\n")
end
