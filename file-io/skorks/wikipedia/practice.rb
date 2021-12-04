require 'open-uri'

url = "http://ruby.bastardsbook.com/files/fundamentals/hamlet.txt"
content = URI.open(url).read
file = File.open('hamlet.txt', 'w')
content.each_line do |line|
  file.puts line
end

file.close

file = File.open('hamlet.txt', 'r')
file.readlines.each_with_index do |line, index|
    if index % 42 == 41
        puts line
    end
end

file.close
