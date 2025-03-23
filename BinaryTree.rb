require_relative 'Node.rb'

class Tree
  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr)
    arr = arr.uniq
    arr = arr.sort

    return nil if arr.empty?

    mid = arr.length / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr[0..mid - 1]) if mid > 0
    root.right = build_tree(arr[mid + 1..-1])

    return root
  end

  #not mine
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(data)
    node = Node.new(data)
    current = @root
    
    loop do

      if node > current
        if current.right.nil?
          current.right = node
          break
        else
          current = current.right
        end

      elsif node < current
        if current.left.nil?
          current.left = node
          break
        else
          current = current.left
        end

      else
        break
      end
    end
  end

  def delete(data)
    node = Node.new(data)
    current = @root

    if node == @root
      if count_from(@root.left) > count_from(@root.right)
        self.root_left
        self.delete_left
      else
        self.root_right
        self.delete_right
      end
    end

    loop do
      if !current.left.nil? && node == current.left
        d_node = current.left
        current.left = nil
        self.insert_children(d_node)
      elsif !current.right.nil? && node == current.right
        d_node = current.right
        current.right = nil
        self.insert_children(d_node)
      end

      if node > current
        if current.right.nil?
          break
        else
          current = current.right
        end

      elsif node < current
        if current.left.nil?
          break
        else
          current = current.left
        end
      end
    end
  end 

  def insert_children(node)

    left = node.left
    right = node.right

    if !left.nil?
      insert_children(left)
      self.insert(left.data)
    end

    if !right.nil?
      insert_children(right)
      self.insert(right.data)
    end
  end

  def count_from(node)
    return 0 if node.nil?
    count = 1
    count += count_from(node.left)
    count += count_from(node.right)
    return count
  end

  def root_left
    root = @root
    while !root.left.nil? do
      rootdp = Node.new(root.data, root.left.left, root.left.right)
      root.data = root.left.data
      root.left = rootdp
      root = root.left
    end
  end

  def delete_left
    root = @root
    while !root.left.left.nil?
      root = root.left
    end
    left = root.left
    root.left = nil
    insert_children(left)
  end

  def root_right
    root = @root
    while !root.right.nil? do
      rootdp = Node.new(root.data, root.right.left, root.right.right)
      root.data = root.right.data
      root.right = rootdp
      root = root.right
    end
  end

  def delete_right
    root = @root
    while !root.right.right.nil?
      root = root.right
    end
    right = root.right
    root.right = nil
    insert_children(right)
  end

  def find(data, node = @root)
    return node if data == node.data
    node.left.nil? ? ret_left = nil : ret_left = find(data, node.left)
    node.right.nil? ? ret_right = nil : ret_right = find(data, node.right)
    ret_left.nil? ? ret_right : ret_left
  end

  def level_order(&block)
    queue = Queue.new
    queue << @root
    ret_arr = Array.new if !block_given?

    while !queue.empty?
      node = queue.pop

      if block_given?
        yield(node)
      else
        ret_arr.push(node.data)
      end
      
      queue.push(node.left) if !node.left.nil?
      queue.push(node.right) if !node.right.nil?
    end

    return ret_arr if !block_given?
  end

  def preorder(node = @root, &block)
    return [] if node.nil?
    ret_arr = Array.new if !block_given?

    if block_given?
      yield(node)
    else
      ret_arr.push(node.data)
    end
    
    pre_left = preorder(node.left, &block)
    pre_right = preorder(node.right, &block)
    ret_arr << pre_left if !block_given?
    ret_arr << pre_right if !block_given?
    
    return ret_arr.flatten if !block_given?
  end

  def inorder(node = @root, &block)
    return [] if node.nil?
    ret_arr = Array.new if !block_given?

    in_left = inorder(node.left, &block)
    in_right = inorder(node.right, &block)
    ret_arr << in_left if !block_given?

    if block_given?
      yield(node)
    else
      ret_arr.push(node.data)
    end
    
    ret_arr << in_right if !block_given?
    
    return ret_arr.flatten if !block_given?
  end

  def postorder(node = @root, &block)
    return [] if node.nil?
    ret_arr = Array.new if !block_given?

    post_left = postorder(node.left, &block)
    post_right = postorder(node.right, &block)
    ret_arr << post_left if !block_given?
    ret_arr << post_right if !block_given?

    if block_given?
      yield(node)
    else
      ret_arr.push(node.data)
    end
    
    return ret_arr.flatten if !block_given?
  end

  def height(node)
    return 0 if node.nil?
    height = 0
    ln = !node.left.nil?
    lr = !node.right.nil?
    left = height(node.left) if ln
    right = height(node.right).to_i if lr
    left.to_i > right.to_i ? height += left : height += right.to_i
    height += 1 if ln || lr
    return height
  end

  def depth(node, level = 0, current = @root)
    return 0 if current.nil?
    return level if node == current
    level += 1
    ret_left = depth(node, level, current.left)
    ret_right = depth(node, level, current.right)
    ret_left > ret_right ? ret_left : ret_right
  end

  def balanced?
    queue = Queue.new
    queue.push(@root)
    while !queue.empty? do
      node = queue.pop
      left, right = node.left, node.right
      return false if (height(left) - height(right)).abs > 1
      queue.push(left) if !left.nil?
      queue.push(right) if !right.nil?
    end
    return true
  end

  def rebalance
    @root = self.build_tree(self.level_order)
  end
end

