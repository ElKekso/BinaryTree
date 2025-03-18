class Node
  include Comparable
  
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    self.data <=> other.data
  end

  def clear_connections
    @left = nil
    @right = nil
  end
end