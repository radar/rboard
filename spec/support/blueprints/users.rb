
User.blueprint do
  login { Faker::Internet.user_name }
  password "password" 
  password_confirmation "password"
  email { Faker::Internet.email }
end


User.blueprint(:anonymous) do
  # group = Group.ensure("Anonymous")
  identifier "anonymous"
  login "anonymous"
  email "anony@mous.com"
end

User.blueprint(:administrator) do
  login "administrator"
  email "administrator@rboard.com"
  permalink "administrator"
  password "godly"
  password_confirmation "godly"
  remember_token_expires_at { Time.now + 2.weeks }
  rank { Rank.find_by_name("God") || Rank.make(:god) }
end

User.blueprint(:moderator) do
  login "moderator"
  email "moderator@rboard.com"
  permalink "moderator"
  password "subbie"
  password_confirmation "subbie"
  remember_token_expires_at { Time.now + 2.weeks }
  rank { Rank.find_by_name("Jesus") || Rank.make(:jesus) }
end

User.blueprint(:registered_user) do
  group = Group.ensure("Registered User")
  login "registered_user"
  login_time { Time.now - 5.minutes }
end

User.blueprint(:banned_noob) do
  group = Group.ensure("Registered User")
  login "banned_noob"
  ban_time { Time.now + 1.week }
  ban_reason "A nusiance."
end