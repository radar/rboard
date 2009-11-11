Given /^there is Nick Crowther's setup$/ do
  Forum.delete_all
  Group.delete_all
  Permission.delete_all
  User.delete_all
  Category.delete_all

  category_1 = Category.make(:name => "Category One")
  category_1.forums.make(:title => "Forum One")
  
  category_2 = Category.make(:name => "Category Two")
  category_2.forums.make(:title => "Forum Two")
  
  # The anonymous user
  User.make_with_group(:anonymous, "Anonymous")
  
  # The registered user
  User.make_with_group(:registered_user, "Registered Users")
  
  User.make_with_group(:nick, { :name => "Group One" }, {:login => "Nick"})
  User.make_with_group(:ryan, { :name => "Group Two" }, {:login => "Ryan"})
  
  group_1 = Group.find_by_name("Group One")
  group_2 = Group.find_by_name("Group Two")
  
  
  Permission.make(:can_see_category => true, :group => group_1, :category => category_1)
  Permission.make(:can_see_category => true, :group => group_2, :category => category_2)
end