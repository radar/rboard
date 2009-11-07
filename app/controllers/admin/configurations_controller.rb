class Admin::ConfigurationsController < Admin::ApplicationController
  before_filter :find_configuration, :only => [:edit, :update]

  def index
    @configurations = Configuration.all
  end


  def update_all
    configurations = Configuration.find_all_by_key(params[:configurations].keys)

    configurations.each do |configuration|
      configuration.update_attributes(params[:configurations][configuration.id])
    end
    flash[:notice] = t(:configuration_settings_updated)
    redirect_to admin_configurations_path  
  end

end
