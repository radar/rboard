require 'rubygems'
require 'fileutils'

rubyforge_name = "textpow"

begin
   require 'hoe'
   
   class Hoe 
      # Dirty hack to eliminate Hoe from gem dependencies
      def extra_deps 
         @extra_deps.delete_if{ |x| x.first == 'hoe' }
      end
   end
   
   version = /^== *(\d+\.\d+\.\d+)/.match( File.read( 'History.txt' ) )[1]
   
   h = Hoe.new('textpow', version) do |p|
      p.rubyforge_name = rubyforge_name
      p.author = ['Dizan Vasquez']
      p.email  = ['dichodaemon@gmail.com']
      p.email = 'dichodaemon@gmail.com'
      p.summary = 'An engine for parsing Textmate bundles'
      p.description = p.paragraphs_of('README.txt', 1 ).join('\n\n')
      p.url = 'http://textpow.rubyforge.org'
      p.rdoc_pattern = /^(lib|bin|ext)|txt$/
      p.changes = p.paragraphs_of('History.txt', 0).join("\n\n")
      p.clean_globs = ["manual/*"]
      p.extra_deps << ['oniguruma', '>= 1.1.0']
      p.extra_deps << ['plist', '>= 3.0.0']
   end
   
   desc 'Create MaMa documentation'
   task :mama => :clean do
      system "mm -c -t refresh -o manual mm/manual.mm"
   end
   
   desc 'Publish MaMa documentation to RubyForge'
      task :mama_publish => [:clean, :mama] do
      config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
      host = "#{config["username"]}@rubyforge.org"
      remote_dir = "/var/www/gforge-projects/#{h.rubyforge_name}"
      local_dir = 'manual'
      system "rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}"
   end

rescue LoadError => e
   desc 'Run the test suite.'
   task :test do
      system "ruby -Ibin:lib:test test_#{rubyforge_name}.rb"
   end
end