task :missing_translations => :environment do
  @missing_translation_count = 0
  for locale in I18n.load_path
    look_for_candidates(File.basename(locale,".*"))
    look_for_candidates(File.basename(locale,".*"), "#{RAILS_ROOT}/lib")
  end
  puts "Total missing translations: #{@missing_translation_count}"
end

def look_for_candidates(locale, dir="#{RAILS_ROOT}/app")
  entries = Dir.entries(dir) - [".", "..", ".svn", ".git"]
  for entry in entries
    alerted = false
    real_entry = File.join(dir, entry)
    if File.directory?(real_entry)
      look_for_candidates(locale, real_entry)
    else
      # dunno, guess some people may use the actual method rather than it's shorter brother
      translations = File.readlines(real_entry).to_s.scan(/\s[t|translate]\(.*?\)/)
      for translation in translations
        translated_to = I18n.t(translation.gsub(/^\s[t|translate]/, "").gsub(/[\(|\)|:]/, "").gsub(/(,.*)/, "").to_sym, :locale => locale)
        if translated_to.include?("translation missing:")
          puts "\n\nTranslations missing in #{real_entry}:" unless alerted
          alerted = true
          @missing_translation_count += 1
          puts "    #{translation} (locale: #{locale})"
        end
      end
    end
  end
  rescue I18n::MissingInterpolationArgument
     puts "\n\nInterpolation possibly missing in #{real_entry}:" unless alerted
     alerted = true
     puts "    INTERPOLATION REQUIRED: #{translation} (locale: #{locale})" 
end