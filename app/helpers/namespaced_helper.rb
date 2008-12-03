module NamespacedHelper
  def selected(name)
    'selected' if (current_page?(:controller => "admin/index") && name == "index") ||
                  (current_page?(:controller => "admin/users") && name == "users" && params[:action] != "ban_ip") ||
                  (current_page?(:controller => "admin/ranks") && name == "ranks") ||
                  (current_page?(:controller => "admin/themes") && name == "themes") ||
                  (current_page?(:controller => "admin/forums") && name == "forums") ||
                  (current_page(:controller => "admin/users") && name == "ip_banning" && params[:action] == "ban_ip")
                  (current_page(:controller => "moderator/moderations") && name == "moderations")
  end
end
