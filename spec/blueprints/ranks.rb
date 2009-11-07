Rank.blueprint do

end

Rank.blueprint(:runner) do
  name "Runner"
  posts_required 0
end

Rank.blueprint(:god) do
  name "God"
  custom true
end