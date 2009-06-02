this = File.expand_path(File.dirname(__FILE__))
Dir[File.join(this, 'blueprints') + "/*.rb"].each do |file|
  require file
end
  
        
        
        
        
        
        