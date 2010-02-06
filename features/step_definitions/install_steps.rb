Given /^I run the installer with the following details:$/ do |table|
  hash = table.hashes.first
  silence_stream(STDOUT) do
    Rboard.install!(hash["login"], hash["password"], hash["email"])
  end
end
