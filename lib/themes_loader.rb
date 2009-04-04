class ThemesLoader
  def initialize
    themes = Dir.entries(THEMES_DIRECTORY).reject { |theme| theme =~ /^\./ }
    if Theme.count != themes.size
      Theme.delete_all  
      (themes.delete_if { |e| /^\./.match(e) || !File.directory?(File.join(THEMES_DIRECTORY, e))}).each { |theme| Theme.create(:name => theme) } 
    end
  end
end