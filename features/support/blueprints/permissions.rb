Permission.blueprint do
  can_see_forum true
  group { Group.ensure("Anonymous") }
end

Permission.blueprint(:registered_users) do
  can_reply_to_topics true
  can_start_new_topics true
  can_subscribe true
  group { Group.ensure("Registered Users") }
end
