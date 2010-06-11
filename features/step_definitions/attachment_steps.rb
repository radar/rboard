When /^I attach the fixture file "([^\"]*)" to "([^\"]*)"$/ do |file, field|
  file = File.join(Rails.root, "spec", "fixtures", file)
  if File.exists?(file)
    When %Q{I attach the file #{file.inspect} to #{field.inspect}}
  else
    raise "The file #{file.inspect} does not exist!"
  end
end