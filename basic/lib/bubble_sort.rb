def bubble_sort(arr)
  n = arr.length
  (0...n).each do |i|
    swapped = false
    (0...n - i - 1).each do |j|
      if arr[j] > arr[j + 1]
        arr[j], arr[j + 1] = arr[j + 1], arr[j]
        swapped = true
      end
    end
    break unless swapped
  end
  arr
end

p bubble_sort([4, 3, 78, 2, 0, 2])
