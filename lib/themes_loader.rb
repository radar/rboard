class ThemesLoader
  def initialize
    themes = Dir.entries(directory).reject { |theme| theme =~ /^\./ }
    if Theme.count != themes.size
      Theme.delete_all  
      (themes.delete_if { |e| /^\./.match(e) || !File.directory?(File.join(directory, e))}).each { |theme| Theme.create(:name => theme) } 
    end
  end

  private

  def directory  
    THEMES_DIRECTORY.respond_to?("call") ? THEMES_DIRECTORY.call() : THEMES_DIRECTORY
  end
end