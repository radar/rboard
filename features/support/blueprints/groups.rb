
Group.blueprint do
  name { Faker::Name.name }
end

Group.blueprint(:administrators) do
  name "Administrators"
end

Group.blueprint(:anonymous) do
  name "Anonymous"
  owner { User.ensure("Administrator") }
end

Group.blueprint(:registered_users) do
  name "Registered Users"
  owner { User.ensure("Administrator") }
end