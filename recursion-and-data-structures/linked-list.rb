class Node 
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

class LinkedList 
  attr_accessor :head

  def initialize
    @head = nil
  end

  def prepend(value)
    new_node = Node.new(value, @head)
    @head = new_node
  end

  def append(value)
    if @head.nil?
      prepend(value)
    else
      last = tail
      tail.next_node = Node.new(value)
    end
  end

  def size 
    curr = @head
    count = 0
    until curr.nil?
      count += 1
      curr = curr.next_node
    end
    count
  end

  def tail
    curr = @head
    curr = curr.next_node until curr.next_node.nil?
    curr
  end

  def at(index)
    unless index < size
      puts "Given index #{index} for at should be smaller than size of list #{size}!"
      return
    end
    curr = @head
    index.times { curr = curr.next_node }
    curr
  end

  def pop
    list_size = size
    if list_size.zero?
      puts "Given index #{index} for at should be smaller than size of list #{size}!"
    elsif list_size == 1
      @head = nil
    else
      curr = @head
      curr = curr.next_node until curr.next_node.next_node.nil?
      curr.next_node = nil
    end
  end

  def contains?(value)
    !find(value).nil?
  end

  def find(value)
    curr = @head
    index = 0
    until curr.nil?
      return index if curr.value == value

      curr = curr.next_node
      index += 1
    end
    nil
  end

  def to_s
    curr = @head
    res = ''
    until curr.nil?
      res += "( #{curr.value} ) -> "
      curr = curr.next_node
    end
    res += 'nil'
    res
  end

  def insert_at(value, index)
    if index.zero?
      prepend(value)
    else  
      curr = @head
      (index - 1).times { curr = curr.next_node }
      new_node = Node.new(value, curr.next_node)
      curr.next_node = new_node
    end
  end

  def remove_at(index)
    if index.zero?
      @head = @head&.next_node
    else
      curr = @head
      (index - 1).times { curr = curr.next_node }
      curr.next_node = curr.next_node.next_node
    end
  end
end

test_list = LinkedList.new
test_list.append(5)
test_list.append(4)
test_list.prepend(3)
p test_list.to_s
p test_list.size
p test_list.head.value
p test_list.tail.value
p test_list.at(2)
p test_list.at(1)
test_list.pop
p test_list.to_s
p test_list.contains?(3)
p test_list.contains?(6)
p test_list.find(3)
p test_list.find(6)
test_list.insert_at(6, 1)
test_list.insert_at(10, 2)
p test_list.to_s
test_list.remove_at(0)
test_list.remove_at(1)
p test_list.to_s
