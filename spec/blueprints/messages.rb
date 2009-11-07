Message.blueprint do
  text { Faker::Lorem.paragraphs.join("\n") }
  from { User.find_by_login("registered_user") }
end