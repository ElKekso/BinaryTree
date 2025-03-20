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
    puts(mid)
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
      
      queue.push(node.right) if !node.right.nil?
      queue.push(node.left) if !node.left.nil?
    end

    return ret_arr if !block_given?
  end
end
