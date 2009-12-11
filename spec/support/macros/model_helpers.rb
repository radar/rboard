#mmmm, meta.
[
  [Forum, "title"],
  [User, "login"]
].each do |klass, method|
  eval <<-EOS 
    def #{klass.to_s}(value)
      #{klass}.send("find_by_#{method}", value)
    end
  EOS
end
