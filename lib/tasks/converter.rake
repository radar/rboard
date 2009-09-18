task :converter => :environment do
  PHPBB::Converter.convert
end