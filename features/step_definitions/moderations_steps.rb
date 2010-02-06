When /^I select "([^\"]*)" for moderation$/ do |subject|
  Then "I should see \"#{subject}\""
  id = Topic.find_by_subject(subject).id
  When "I check \"topic_#{id}_moderated\""
end

Then /^I should (not )?see the button to "([^\"]*)"$/ do |no, name|
  Nokogiri::HTML(response.body).xpath("//input[@type='submit']").detect { |input| input["value"] == name }.send(no ? "should" : "should_not", be_nil)
end

