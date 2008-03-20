class Admin::ThemesController < Admin::ApplicationController
  
  def index
    #FIXME: possibly CPU intensive, and may need to be done else where.
    @themes = Dir.entries("#{RAILS_ROOT}/public/themes") - ['.svn','..','.']
    @themes.each { |theme| Theme.create(:name => theme) }
    @themes = Theme.find(:all)
    for theme in @themes
      if !File.exist?("#{RAILS_ROOT}/public/themes/#{theme.name}")
        @themes -= [theme]
        theme.destroy
      end
    end
  end
  
end
