require_relative 'Node.rb'

class Tree
  def initialize
    @root = nil
  end

  def build_tree(arr)
    arr = arr.uniq
    arr = arr.sort

    return nil if arr.empty?

    mid = arr.length / 2
    root = Node.new(arr[mid])

    root.left(build_tree(arr[0..mid - 1]))
    root.right(build_tree(arr[mid + 1..-1]))

    return root
  end
end