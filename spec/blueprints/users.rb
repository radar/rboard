
User.blueprint do
  login { Faker::Internet.user_name }
  password "password" 
  password_confirmation "password"
  email { Faker::Internet.email }
  groups { Group.ensure("Registered Users") }
end


User.blueprint(:anonymous) do
  group = Group.find_by_name("Anonymous") || Group.make(:anonymous) 
  login "anonymous"
  email "anony@mous.com"
end

User.blueprint(:administrator) do
  group = Group.find_by_name("administrator") || Group.make(:administrator) 
  login "administrator"
  email "administrator@rboard.com"
  permalink "administrator"
end

User.blueprint(:registered_user) do
  group = Group.find_by_name("Registered User") || Group.make(:registered_user) 
  login "registered_user"
end