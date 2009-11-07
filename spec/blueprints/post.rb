Post.blueprint do
  text { Faker::Lorem.paragraphs.join("\n") }
end