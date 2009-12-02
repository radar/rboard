for file in Dir["**/*"]
  if File.file?(file)
    lines = File.readlines(file).map { |line| line.gsub(/^\s+$/, "\n") }
    File.open(file, "w+") { |f| f.write(lines.join) }
  end
end