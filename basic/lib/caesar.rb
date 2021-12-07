def convert(char, num)
  return char if !('a'..'z').include?(char) && !('A'..'Z').include?(char)

  a = if char == char.upcase
        'A'
      else
        'a'
      end
  ((char.ord - a.ord + num) % 26 + a.ord).chr
end

def caesar_cipher(string, num)
  res = ''
  string.each_char { |c| res += convert(c, num) }
  res
end

puts caesar_cipher('What a string!', 5)
