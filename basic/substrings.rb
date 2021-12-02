def substrings(word, array)
  word.downcase!
  array.each_with_object({}) do |w, acc|
    # can replace .gsub.to_a with scan
    count = word.gsub(w).to_a.length
    acc[w] = count unless count === 0
  end
end
dictionary = %w[below down go going horn how howdy it i low own part partner sit]
puts substrings('below', dictionary)

puts substrings("Howdy partner, sit down! How's it going?", dictionary)
