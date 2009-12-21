module Admin::PermissionsHelper
  def sections
    [:admin,
     :moderator]
  end

  def managements
    [:bans,
     :categories,
     :edits,
     :forums,
     :groups,
     :ips,
     :moderations,
     :posts,
     :ranks,
     :themes,
     :topics]
  end

  def break_row(count)
    "</tr><tr>" if (count + 1) % 5 == 0
  end

  def forum_permissions
    [:can_delete_own_posts,
     :can_delete_posts,
     :can_delete_topics,
     :can_edit_locked_topics,
     :can_edit_own_posts,
     :can_edit_own_topics,
     :can_edit_posts,
     :can_edit_topics,
     :can_lock_own_topics,
     :can_lock_topics,
     :can_merge_topics,
     :can_move_topics,
     :can_post_stickies,
     :can_reply_to_locked_topics,
     :can_reply_to_topics,
     :can_see_category,
     :can_see_forum,
     :can_split_topics,
     :can_start_new_topics,
     :can_post_in_closed_forums,
     :can_subscribe,
     :can_see_hidden_edits]
  end

  def global_permissions
    [:can_read_private_messages,
     :can_reply,
     :can_send_messages_to_groups,
     :can_use_signature]
  end

end

