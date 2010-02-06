Permission.blueprint do
  can_see_forum true
  can_see_category true
  group { Group.ensure("Anonymous") }
end

Permission.blueprint(:moderators) do
  can_reply_to_topics true
  can_start_new_topics true
  can_subscribe true
  can_read_private_messages true
  can_access_moderator_section true
  can_manage_moderations true
  can_manage_posts true
  can_manage_topics true
  can_merge_topics true
  # We would continue to add the rest here but it'd be best doing it as they're required.
  # This is to ensure that we've covered all scenarios.
  group { Group.ensure("Moderators") }
end

Permission.blueprint(:registered_users) do
  can_reply true
  can_reply_to_topics true
  can_start_new_topics true
  can_subscribe true
  can_edit_own_posts true
  can_edit_own_topics true
  can_read_private_messages true
  group { Group.ensure("Registered Users") }
end

Permission.blueprint(:administrators) do
  can_see_forum true
  can_reply_to_topics true
  can_post_stickies true
  can_start_new_topics true
  can_post_in_closed_forums true
  can_use_signature true
  can_delete_own_posts true
  can_edit_own_posts true
  can_subscribe true
  can_lock_own_topics true
  can_ignore_flood_limit true
  can_delete_posts true
  can_edit_posts true
  can_lock_topics true
  can_merge_topics true
  can_move_topics true
  can_split_topics true
  can_sticky_topics true
  can_send_multiple_messages true
  can_send_messages_to_groups true
  can_read_private_messages true
  can_manage_groups true
  can_manage_bans true
  can_manage_edits true
  can_manage_ips true
  can_manage_posts true
  can_manage_ranks true
  can_manage_users true
  can_manage_themes true
  can_manage_topics true
  can_manage_forums true
  can_manage_categories true
  can_reply_to_locked_topics true
  can_edit_topics true
  can_reply true
  can_edit_locked_topics true
  can_access_admin_section true
  can_see_category true
  can_access_moderator_section true
  can_read_others_private_messages true
  can_silently_edit true
  can_see_hidden_edits true
  group { Group.ensure("Administrators") }
end

