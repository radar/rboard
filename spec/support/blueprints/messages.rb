Message.blueprint do
  text { Faker::Lorem.paragraphs.join("\n") }
  from { User("registered_user") }
end