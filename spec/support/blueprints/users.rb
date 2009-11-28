
User.blueprint do
  login { Faker::Internet.user_name }
  password "password" 
  password_confirmation "password"
  email { Faker::Internet.email }
end


User.blueprint(:anonymous) do
  # group = Group.ensure("Anonymous")
  login "anonymous"
  email "anony@mous.com"
end

User.blueprint(:administrator) do
  # group = Group.ensure("Administrator")
  login "administrator"
  email "administrator@rboard.com"
  permalink "administrator"
  password "godly"
  password_confirmation "godly"
  remember_token_expires_at { Time.now + 2.weeks }
  rank { Rank.find_by_name("God") || Rank.make(:god) }
end

User.blueprint(:registered_user) do
  group = Group.ensure("Registered User")
  login "registered_user"
  login_time { Time.now - 5.minutes }
end

User.blueprint(:banned_noob) do
  group = Group.ensure("Registered User")
  login "Banned Noob"
  ban_time { Time.now + 1.week }
  ban_reason "A nusiance."
end