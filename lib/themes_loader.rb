class ThemesLoader
  def initialize
    if Theme.count != Dir.entries(THEMES_DIRECTORY).size
      Theme.delete_all  
      (Dir.entries(THEMES_DIRECTORY).delete_if { |e| /^\./.match(e) || !File.directory?(File.join(THEMES_DIRECTORY, e))}).each { |theme| Theme.create(:name => theme) } 
    end
  end
end