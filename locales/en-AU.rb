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
   :administrator_should_create_forum => "Maybe an administrator should create one.",
   :ago => "ago",
   :Author => "Author",
   :by => "by",
   :Delete => "Delete",
   :Edit_Profile => "Edit Profile",
   :forum_statistics => "Forum Statistics",
   :Forum => "Forum",
   :Home => "Home",
   :Last_Post => "Last Post",
   :Lock => "Lock",
   :Login => "Login",
   :Logout => "Logout",
   :Member_List => "Member List",
   :Moderation => "Moderation",
   :Move => "Move",
   :New_Topic => "New Topic",
   :no_forums => "There are no forums.", 
   :None => "None",
   :posts_per_topic => "Posts per topic",
   :Posts => "Posts",
   :rBoard => "rBoard", 
   :recent_users => "Users on in the last 15 minutes",
   :registered_users => "Registered Users",
   :Replies => "Replies",
   :Search => "Search",
   :Signup => "Signup",
   :Sticky => "Sticky",
   :time_now => "The time is now",
   :Topic => "Topic",
   :Topics => "Topics",
   :Unlock => "Unlock",
   :Unsticky => "Unsticky",
   :Viewing_forum => "Viewing forum",
   :Views => "Views",
   :wrote => "wrote:",
   :x_new_messages => {:zero => 'No new messages', :one => 'One new message', :other => '{{count}} new messages'},
   :you_should_create_forum => "Maybe you should create a forum."
  }
}