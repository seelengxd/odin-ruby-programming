# frozen_string_literal: true

# Assignment 1: Fibonacci Sequence

def fibs(n)
  arr = []
  n.times do |i|
    arr[i] = i <= 1 ? i : arr[-1] + arr[-2]
  end
  arr
end

def fibs_rec(n)
  case n
  when 1
    [0]
  when 2
    [0, 1]
  else
    wish = fibs_rec(n - 1)
    wish << wish[-1] + wish[-2]
    wish
  end
end

p fibs(5)
p fibs_rec(5)

# Assignment 2: Merge Sort

def merge_sort(arr)
  if arr.length < 2
    arr
  else
    left = arr[0...arr.length / 2]
    right = arr[arr.length / 2...]
    merge(merge_sort(left), merge_sort(right))
  end
end

def merge(left, right)
  result = []
  left_length = left.length
  right_length = right.length
  left_pointer = 0
  right_pointer = 0
  while left_pointer < left_length && right_pointer < right_length do
    if left[left_pointer] <= right[right_pointer]
      result << left[left_pointer]
      left_pointer += 1
    else
      result << right[right_pointer]
      right_pointer += 1
    end
  end
  result + left[left_pointer...] + right[right_pointer...]
end

p merge_sort(10.times.map { rand(10) })
