#mmmm, meta.
[
  [Forum, "title"],
  [User, "login"],
  [Group, "name"],
  [Rank, "name"]
].each do |klass, method|
  eval <<-EOS 
    def #{klass.to_s}(value)
      #{klass}.send("find_by_#{method}!", value.to_s)
    end
  EOS
end
