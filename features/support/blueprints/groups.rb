
Group.blueprint do
  name { Faker::Name.name }
end

Group.blueprint(:administrators) do
  name "Administrators"
  identifier "administrators"
end

Group.blueprint(:anonymous) do
  name "Anonymous"
  identifier "anonymous"
  owner { User.ensure("Administrator") }
end

Group.blueprint(:registered_users) do
  name "Registered Users"
  identifier "registered_users"
  owner { User.ensure("Administrator") }
end