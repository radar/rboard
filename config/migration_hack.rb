# I love the smell of hax in the morning.
if ARGV[0] == "db:migrate"
  
  lines = File.readlines("config/environment.rb")
  lines.delete_if { |l| l == "require 'config/migration_hack'\n"}
  f = File.open("config/environment.rb", "w+")
  f.write(lines.join(""))
  f.close
  
  FileUtils.rm(__FILE__)
  raise "If you are REALLY REALLY SURE you want to run rake db:migrate consider this first:
        If you have not yet run rake install (to install rBoard), running db:migrate will override db/schema.rb. This is a Bad Thing(tm).
        This is your first, last and ONLY warning. Running rake db:migrate again will result in the expected results.
        You have been warned!"

end