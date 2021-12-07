class Node
  attr_accessor :value, :left, :right, :parent

  def initialize(value, left = nil, right = nil, parent: nil)
    @value = value
    @left = left
    @right = right
    @parent = parent
  end

  def children_count
    count = 0
    count += 1 unless left.nil?
    count += 1 unless right.nil?
    count
  end

  def next_bigger
    curr = self.right
    until curr.left.nil?
      curr = curr.left
    end
    curr
  end

  def inorder(block = nil)
    if block.nil?
      res = []
      left_part = left&.inorder
      right_part = right&.inorder
      res += left_part unless left_part.nil?
      res << self
      res += right_part unless right_part.nil?
      res
    else
      left.&inorder(block)
      block.call(self)
      right.&inorder(block)
    end
  end

  def preorder(block = nil)
    if block.nil?
      res = []
      left_part = left&.preorder
      right_part = right&.preorder
      res << self
      res += left_part unless left_part.nil?
      res += right_part unless right_part.nil?
      res
    else
      block.call(self)
      left.&preorder(block)
      right.&preorder(block)
    end
  end

  def postorder(block = nil)
    if block.nil?
      res = []
      left_part = left&.postorder
      right_part = right&.postorder
      res += left_part unless left_part.nil?
      res += right_part unless right_part.nil?
      res << self
      res
    else
      left.&postorder(block)
      right.&postorder(block)
      block.call(self)
    end
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    p array.sort
    @root = Tree.build_tree(array.sort)
  end

  def self.build_tree(array, parent: nil)
    array_length = array.length
    return nil if array_length.zero?

    mid = array_length / 2
    new_node = Node.new(array[mid], parent: parent)
    new_node.left = self.build_tree(array[...mid], parent: new_node)
    new_node.right = self.build_tree(array[mid + 1...], parent: new_node)
    new_node
  end

  def insert(value)
    if @root.nil?
      @root = Node.new(value)
    else
      curr = @root
      new_node = Node.new(value)
      loop do
        if value < curr.value
          if curr.left.nil?
            curr.left = new_node
            new_node.parent = curr
            break
          else
            curr = curr.left
          end
        else
          if curr.right.nil?
            curr.right = new_node
            new_node.parent = curr
            break
          else
            curr = curr.right
          end
        end
      end
    end
  end

  def delete(value)
    p value
    target = find(value)
    parent = target.parent
    if target.children_count == 2
      next_bigger = target.next_bigger
      new_value = next_bigger.value
      delete(new_value)
      target.value = new_value
      return
    end
    unless parent.nil?
      if target.children_count == 0
        if parent.left == self
          parent.left = nil
        else
          parent.right = nil
        end
      else
        child = target.left.nil? ? target.left : target.right
        if parent.left == self
          parent.left = child
          child.parent = parent
        else
          parent.right = child
          child.parent = parent
        end
      end
    else
      if target.children_count == 0
        @root = nil
      else
        child = target.left.nil? ? target.right : target.left
        @root = child
      end
    end

  end

  def find(value)
    curr = @root
    until curr.nil?
      return curr if curr.value == value
      curr = curr.value > value ? curr.left : curr.right
    end
    nil
  end

  def level_order
    queue = []
    res = []
    queue << @root unless @root.nil?
    while queue.length.positive?
      curr = queue.shift
      if block_given?
        yield(curr)
      else
        res << curr
      end
      queue << curr.left unless curr.left.nil?
      queue << curr.right unless curr.right.nil?
    end
    res unless block_given?
  end

  def inorder(&block)
    @root.inorder(block) unless @root.nil?
  end

  def preorder(&block)
    @root.preorder(block) unless @root.nil?
  end

  def postorder(&block)
    @root.postorder(block) unless @root.nil?
  end

  def height(node)
    node.nil? ? -1 : 1 + [height(node.left), height(node.right)].max
  end

  def depth(node)
    ans = 0
    until node.parent.nil?
      node = node.parent
      ans += 1
    end
    ans
  end

  def balanced?
    inorder.all? { |node| (height(node.left) - height(node.right)).abs <= 1}
  end

  def rebalance
    @root = Tree.build_tree(inorder)
  end

end

test_tree = Tree.new((Array.new(15) { rand(1..100) }).uniq)
p test_tree.balanced?
p test_tree.preorder.map { |node| node.value }
p (test_tree.preorder.map { |node| node.parent&.value }).class
p test_tree.delete(test_tree.root.value)
p test_tree.preorder.map { |node| node.value }
p test_tree.balanced?
p test_tree.level_order.map { |node| node.value }
p test_tree.inorder.map { |node| node.value }
p test_tree.preorder.map { |node| node.value }
p test_tree.postorder.map { |node| node.value }

5.times { test_tree.insert( rand(101..200)) }

p test_tree.balanced?
test_tree.rebalance
p test_tree.balanced?