When /^I select "([^\"]*)" for moderation$/ do |title|
  # All of this just to get the ID of the corresponding topic.
  # Sure we could do a find, but that doesn't *prove* that the topic is on the page.
  # We want proof. Gorgeous, proof.
  id = Nokogiri::HTML(response.body).xpath("//a").detect { |a| a.text == title }["href"].split("/").last
  When "I check \"topic_#{id}_moderated\""
end

Then /^I should (not )?see the button to "([^\"]*)"$/ do |no, name|
  Nokogiri::HTML(response.body).xpath("//input[@type='submit']").detect { |input| input["value"] == name }.send(no ? "should" : "should_not", be_nil)
end

