
User.blueprint do
  login { Faker::Internet.user_name }
  password "password" 
  password_confirmation "password"
  email { Faker::Internet.email }
  groups { Group.ensure("Registered Users") }
end


User.blueprint(:anonymous) do
  group = Group.ensure("Anonymous")
  login "anonymous"
  email "anony@mous.com"
end

User.blueprint(:administrator) do
  group = Group.ensure("Administrator")
  login "administrator"
  email "administrator@rboard.com"
  permalink "administrator"
end

User.blueprint(:registered_user) do
  group = Group.ensure("Registered User")
  login "registered_user"
end