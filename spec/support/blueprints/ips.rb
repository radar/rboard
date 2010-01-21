Ip.blueprint do

end

Ip.blueprint(:localhost) do
  ip "127.0.0.1"
  user { User.find_by_login("registered_user") || User.make(:registered_user) }
end