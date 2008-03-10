module AdminHelper
  def selected(name)
    if (params[:controller] == "admin/index" && name == "index") ||
       (params[:controller] == "admin/accounts" && name == "users" && params[:action] != "ban_ip") ||
       (params[:controller] == "admin/ranks" && name == "ranks") ||
       (params[:controller] == "admin/themes" && name == "themes") ||
       (params[:controller] == "admin/forums" && name == "forums") ||
       (params[:controller] == "admin/accounts" && name == "ip_banning" && params[:action] == "ban_ip")
      'selected'
    end
  end
end
