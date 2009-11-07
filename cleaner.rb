for file in Dir["app/**/*"]
  lines = File.readlines(file).map { |line| line.gsub(/^\s+$/, "") }
  File.open(file, "w+") { |f| f.write(lines.join("\n")) }
end