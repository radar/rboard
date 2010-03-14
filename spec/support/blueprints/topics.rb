Topic.blueprint do
  subject "Default topic"
  user { User.ensure(:administrator) }
  ip { Ip.make(:localhost) }
end