for file in Dir["app/**/*"]
  if File.file?(file)
    lines = File.readlines(file).map { |line| line.gsub(/^\s+$/, "") }
    File.open(file, "w+") { |f| f.write(lines.join) }
  end
end