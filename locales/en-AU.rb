{
  :'en-AU' => {
    :date => {
      :formats => {
        :default      => "%d/%m/%Y",
        :short        => "%e %b",
        :long         => "%e %B, %Y",
        :long_ordinal => lambda { |date| "#{date.day.ordinalize} %B, %Y" },
        :only_day     => "%e"
      },
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES,
      :order => [:year, :month, :day]
    },
    :time => {
      :formats => {
        :default      => "%a %b %d %H:%M:%S %Z %Y",
        :time         => "%H:%M",
        :short        => "%d %b %H:%M",
        :long         => "%d %B, %Y %H:%M",
        :long_ordinal => lambda { |time| "#{time.day.ordinalize} %B, %Y %H:%M" },
        :only_second  => "%S"
      },
      :datetime => {
        :formats => {
          :default => "%Y-%m-%dT%H:%M:%S%Z"
        }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => 'half a minute',
        :less_than_x_seconds => {:zero => 'less than a second', :one => 'less than a second', :other => 'less than {{count}} seconds'},
        :x_seconds           => {:one => '1 second', :other => '{{count}} seconds'},
        :less_than_x_minutes => {:zero => 'less than a minute', :one => 'less than a minute', :other => 'less than {{count}} minutes'},
        :x_minutes           => {:one => "1 minute", :other => "{{count}} minutes"},
        :about_x_hours       => {:one => 'about 1 hour', :other => 'about {{count}} hours'},
        :x_days              => {:one => '1 day', :other => '{{count}} days'},
        :about_x_months      => {:one => 'about 1 month', :other => 'about {{count}} months'},
        :x_months            => {:one => '1 month', :other => '{{count}} months'},
        :about_x_years       => {:one => 'about 1 year', :other => 'about {{count}} years'},
        :over_x_years        => {:one => 'over 1 year', :other => 'over {{count}} years'}
      }
    },
    :number => {
      :format => {
        :precision => 2,
        :separator => ',',
        :delimiter => '.'
      },
      :currency => {
        :format => {
          :unit => 'AUD',
          :precision => 2,
          :format => '%n %u'
        }
      }
    },

    # Active Record
    :active_record => {
      :error => {
        :header_message => ["Couldn't save this {{object_name}}: 1 error", "Couldn't save this {{object_name}}: {{count}} errors."],
        :message => "Please check the following fields:"
      }
    },
    :active_record => {
      :error_messages => {
        :inclusion => "is not in the list",
        :exclusion => "is excluded",
        :invalid => "is invalid",
        :confirmation => "doesn't match the confirmation",
        :accepted  => "have to be accepted",
        :empty => "cannot be empty",
        :blank => "cannot be blank",
        :too_long => "is too long (no more than {{count}} characters)",
        :too_short => "is too short (no less than {{count}} characters)",
        :wrong_length => "is the wrong length (gotta be {{count}} characters)",
        :taken => "is taken",
        :not_a_number => "is not number",
        :greater_than => "should be greater than {{count}}",
        :greater_than_or_equal_to => "should be greater than or equal to {{count}}",
        :equal_to => "should be equal to {{count}}",
        :less_than => "should be less than {{count}}",
        :less_than_or_equal_to => "should be less than or equal to {{count}}",
        :odd => "should be odd",
        :even => "should be even"
      }
    },
   :about => "about",
   :admin_section => "Admin Section",
   :Administrator => "Administrator",
   :administrator_should_create_forum => "Maybe an administrator should create one.",
   :ago => "ago",
   :already_logged_in => "You are already logged in.",
   :Author => "Author",
   :ban_expires_in => "Ban expires in {{time}}",
   :Bans => "Bans",
   :Banned => "Banned",
   :Banned_until => "Banned until",
   :banned_by => "banned by {{user}}",
   :by => "by",
   :Confirm_Password => "Confirm Password",
   :confirm_user_ban => "Are you sure you want to ban this user?",
   :confirm_user_deletion => "Are you sure you want to delete this user?",
   :custom_rank => "custom rank",
   :Date_joined => "Date joined",
   :Delete => "Delete",
   :Do_not_have_a_user => "Don't have a user?",
   :Edit => "Edit",
   :Edit_Profile => "Edit Profile",
   :editing_a_user => "Editing a user",
   :Email => "Email",
   :email => "email",
   :forum_statistics => "Forum Statistics",
   :Forum => "Forum",
   :Home => "Home",
   :has_been_banned => "has been banned",
   :in => "in",
   :invalid_format => "Invalid format.",
   :IP => "IP",
   :is_currently_banned => "{{user}} is currently banned",
   :Last_Post => "Last Post",
   :Lock => "Lock",
   :Lock_this_topic => "Lock this topic",
   :Login => "Login",
   :login => "login",
   :logged_in_successfully => "Logged in successfully.",
   :Logout => "Logout",
   :Member_List => "Member List",
   :Member_since => "Member since",
   :message_could_not_be_sent => "This message could not be sent.",
   :message_sent => "The message has been sent.",
   :message_does_not_belong_to_you => "That message does not belong to you.",
   :Moderation => "Moderation",
   :Moderator => "Moderator",
   :Move => "Move",
   :New_Reply => "New Reply",
   :New_Topic => "New Topic",
   :never => "never",
   :no => "no",
   :no_forums => "There are no forums.",
   :not_allowed_to_view_topics => "You are not allowed to view topics in that forum.",
   :None => "None",
   :of_all_posts => "of all posts",
   :of_all_posts_on_this_forum => "of all posts in this forum",
   :Password => "Password",
   :password => "password",
   :post_created => "Post has been created.",
   :post_does_not_exist => "The post you were looking for could not be found.",
   :post_or_edit_not_found => "The post or edit you were looking for cannot be found.",
   :post_was_deleted => "Post was deleted.",
   :post_not_created => "This post could not be created.",
   :post_not_updated => "This post could not be updated.",
   :posts_per_topic => "Posts per topic",
   :Posts => "Posts",
   :problem_during_signup => "There was a problem during signup.",
   :Quote => "Quote",
   :rBoard => "rBoard", 
   :reason_stated_was => "reason stated was: {{reason}}",
   :Remember_me => "Remember me",
   :recent_users => "Users on in the last 15 minutes",
   :registered_users => "Registered Users",
   :Reply => "Reply",
   :Replies => "Replies",
   :Search => "Search",
   :Signup => "Signup",
   :signature => "signature",
   :Split => "Split",
   :Splitting => "Splitting",
   :Sticky => "Sticky",
   :thanks_for_signing_up => "Thanks for signing up!",
   :time_now => "The time is now",
   :Times_banned => "Times banned",
   :times => "times",
   :Topic => "Topic",
   :topic_created => "Topic has been created.",
   :topic_not_created => "Topic was not created.",
   :topic_too => " This was the only post in the topic, so topic was deleted also.",
   :Topics => "Topics",
   :topics_locked => "All selected topics have been locked.",
   :topics_unlocked => "All selected topics have been unlocked.",
   :topics_deleted => "All selected topics have been deleted.",
   :topics_stickied => "All selected topics have been stickied.",
   :topics_unstickied => "All selected topics have been unstickied.",
   :Unlock => "Unlock",
   :Unsticky => "Unsticky",
   :User => "User",
   :user_does_not_exist => "The user you are looking for does not exist.",
   :username_or_password_incorrect => "The username or password you provided is incorrect. Please try again.",
   :user_level => "user level",
   :users => "users",
   :Viewing_forum => "Viewing forum",
   :Views => "Views",
   :wrote => "wrote:",
   :x_new_messages => {:zero => 'No new messages', :one => 'One new message', :other => '{{count}} new messages'},
   :yes => "yes",
   :you_should_create_forum => "Maybe you should create a forum."
  }
}