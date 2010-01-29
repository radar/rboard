Then /^I should see a quote by "([^\"]*)" that says "([^\"]*)"$/ do |name, quote|
  quote_box = Nokogiri::HTML(response.body).css(".post .quote").first
  quote_box.css("b").text.should eql("#{name} wrote:")
  quote_box.css("span").text.should eql(quote)
end
