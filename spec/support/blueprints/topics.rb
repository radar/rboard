Topic.blueprint do
  subject "Default topic"
  user { User.ensure(:administrator) }
end