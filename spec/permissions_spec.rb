require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe User do

  before do
    setup_user_base
    setup_forums
  end

  describe User, "who is in the administrator group with given permissions" do

    before do
      @user = User("administrator")
      @forum = Forum("Admins Only")
    end

    it "should be able to see a forum" do
      @user.can?(:see_forum).should be_true
      @user.can?(:see_forum, @forum).should be_true
    end

    it "should be able to reply to topics" do
      @user.can?(:reply_to_topics).should be_true
    end

    it "should be able to post stickies" do
      @user.can?(:post_stickies).should be_true
    end

    it "should be able to start new topics" do
      @user.can?(:start_new_topics).should be_true
    end

    it "should be able to use the signature" do
      @user.can?(:use_signature).should be_true
    end

    it "should be able to delete own posts" do
      @user.can?(:delete_own_posts).should be_true
    end

    it "should be able to subscribe to topics" do
      @user.can?(:subscribe).should be_true
    end

    it "should be able to lock own topics" do
      @user.can?(:lock_own_topics).should be_true
    end

    it "should be able to ignore the flood limit" do
      @user.can?(:ignore_flood_limit).should be_true
    end

    it "should be able to delete any post" do
      @user.can?(:delete_posts).should be_true
    end

    it "should be able to edit any post" do
      @user.can?(:edit_posts).should be_true
    end

    it "should be able to lock any topic" do
      @user.can?(:lock_topics).should be_true
    end

    it "should be able to merge any topics" do
      @user.can?(:merge_topics).should be_true
    end

    it "should be able to move any topics" do
      @user.can?(:move_topics).should be_true
    end

    it "should be able to split any topic" do
      @user.can?(:split_topics).should be_true
    end

    it "should be able to send multiple messages" do
      @user.can?(:send_multiple_messages).should be_true
    end

    it "should be able message groups" do
      @user.can?(:send_messages_to_groups).should be_true
    end

    it "should be able to read private messages" do
      @user.can?(:read_private_messages).should be_true
    end

    it "should be able to manage groups" do
      @user.can?(:manage_groups).should be_true
    end

    it "should be able to manage bans" do
      @user.can?(:manage_bans).should be_true
    end

    it "should be able to manage ranks" do
      @user.can?(:manage_ranks).should be_true
    end

    it "should be able to manage users" do
      @user.can?(:manage_users).should be_true
    end

    it "should be able to manage forums" do
      @user.can?(:manage_forums).should be_true
    end

    it "should be able to manage categories" do
      @user.can?(:manage_categories).should be_true
    end

    it "should be able to reply to locked topics" do
      @user.can?(:reply_to_locked_topics).should be_true
    end

    it "should be able to edit any topic" do
      @user.can?(:edit_topics).should be_true
    end

    it "should be able to post a reply" do
      @user.can?(:reply).should be_true
    end

    it "should be able to edit locked topics" do
      @user.can?(:edit_locked_topics).should be_true
    end

    it "should be able to access the admin section" do
      @user.can?(:access_admin_section).should be_true
    end

    it "should be able to access the moderator section" do
      @user.can?(:access_moderator_section).should be_true
    end

    it "should be able to see any category" do
      @user.can?(:see_category).should be_true
    end

  end

  describe User, "who is in the registered users group with given permissions" do

    before do
      @user = User("registered_user")
      @admin_forum = Forum("Admins Only")
      @registered_user_forum = Forum("Sub of Public Forum")
    end

    it "should not be able to see the specified forum" do
      @user.can?(:see_forum, @admin_forum).should be_false
    end

    it "should be able to see the registered users forum" do
      @user.can?(:see_forum, @registered_user_forum).should be_true
    end
  end

  describe User, "who is in the anonymous group with given permissions" do

    before do
      @user = User("anonymous")
      @admin_forum = Forum("Admins Only")
      @registered_user_forum = Forum("Sub of Public Forum")
      @everybody = Forum("Public Forum")
    end

    it "should not be able to see the specified forum" do
      @user.can?(:see_forum, @admin_forum).should be_false
    end

    it "should not be able to see the registered users forum" do
      @user.can?(:see_forum, @registered_user_forum).should be_true
    end

    it "should be able to see the everybody forum" do
      @user.can?(:see_forum, @everybody).should be_true
    end
  end
end