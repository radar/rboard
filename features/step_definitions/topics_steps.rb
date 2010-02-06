Then /^I should see (\d+) sticky topics?$/ do |num|
  Nokogiri::HTML(response.body).xpath("//img[@src]").select { |i| i['src'].match(/sticky/) }.size.should eql(num.to_i)
end

Then /^I should see (\d+) locked topics?$/ do |num|
  Nokogiri::HTML(response.body).xpath("//img[@src]").select { |i| i['src'].match(/locked/) }.size.should eql(num.to_i)
end
