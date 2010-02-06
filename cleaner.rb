files = Dir["**/*"]
ignored_files = [
  "development.log"
]
for file in files - ignored_files
  p file
  if File.file?(file)
    lines = File.readlines(file).map { |line| line.gsub(/^\s+$/, "\n") }
    File.open(file, "w+") { |f| f.write(lines.join) }
  end
end