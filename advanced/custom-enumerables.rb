module Enumerable
  def my_each
    if self.is_a? Hash
      for k in self.keys
        yield k, self[k]
      end
    else
      for i in self do 
        yield i
      end
    end
  end

  def my_each_with_index
    if block_given?
      index = 0
      my_each do |item| 
        yield(item, index)
        index += 1
      end
    else
      Enumerator.new do |yielder|
        for i in 0...self.length do 
          yielder << [self[i], i]
        end
      end
    end
  end

  def my_select
    result = []
    my_each { |item| result << item if yield(item)}
    result
  end

  def my_all?
    my_each { |item| return false unless yield(item)}
    true
  end

  def my_none?
    my_each { |item| return true unless yield(item)}
    false
  end

  def my_count(arg = nil)
    ans = 0
    if block_given?
      my_each { |item| ans += 1 if yield(item) }
    elsif !arg.is_a? NilClass
      my_each { |item| ans += 1 if item == arg }
    else
      ans = length
    end
    ans
  end

  def my_map(proc = nil)
    if !proc.nil?
      arr = []
      my_each { |item| arr << proc.call(item) }
      arr
    elsif block_given?
      arr = []
      my_each { |item| arr << yield(item) }
      arr
    else
      Enumerator.new do |yielder|
        my_each { yielder << item }
      end
    end
  end

  def my_inject(initial = nil, sym = nil)
    if (!initial.nil? & !sym.nil?)
      sym = sym.to_proc
      my_each { |item| initial = sym.call(initial, item) }
    elsif !block_given?
      sym = initial.to_proc
      my_each_with_index do |item, index|
        initial = index.zero? ? item : sym.call(initial, item)
      end
    elsif !initial.nil?
      my_each { |item| initial = yield(initial, item) }
    else
      my_each_with_index do |item, index|
        initial = index.zero? ? item : yield(initial, item)
      end
    end
    initial
  end


end

arr = [1, 2, 3]
arr.my_each { |i| puts i }

arr.my_each_with_index { |x, i| p [x, i] }
p arr.my_each_with_index.take 3

p [2, 4, 5].my_all? { |i| i.positive? }
p [2, 4, 5].my_all? { |i| i % 2 == 0 }

x = {a: 5, b: 10}

# my_count test
ary = [1, 2, 4, 2]
p ary.my_count               #=> 4
p ary.my_count(2)            #=> 2
p ary.my_count { |x| x%2==0 } #=> 3

p arr.my_map { |item| item * 2 }

p arr.map.take 3

(1..5).my_each {|item| p item}

# my_inject test

# Sum some numbers
p (5..10).my_inject(:+)                             #=> 45
# Same using a block and inject
p (5..10).my_inject { |sum, n| sum + n }            #=> 45
# Multiply some numbers
p (5..10).my_inject(1, :*)                          #=> 151200
# Same using a block
p (5..10).my_inject(1) { |product, n| product * n } #=> 151200
# find the longest word
longest = %w{ cat sheep bear }.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest                                        #=> "sheep"


def multiply_els(arr)
  arr.my_inject(:*)
end

p multiply_els([2, 4, 5]) #=> 40

# map test
square = Proc.new { |x| x ** 2 }
p arr.my_map(square) { |x| x ** 3 }
p arr.my_map { |x| x ** 3 }