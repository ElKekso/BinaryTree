require_relative 'BinaryTree.rb'

def order_print(bn)
  puts("level_order #{bn.level_order}")
  puts("preorder #{bn.preorder}")
  puts("postorder #{bn.postorder}")
  puts("inorder #{bn.inorder}")
end

bn = Tree.new((Array.new(15) { rand(1..100) }))
puts("balanced? : #{bn.balanced?}")
order_print(bn)
bn.insert(102)
bn.insert(3002)
bn.insert(233)
bn.insert(406)
puts("balanced? : #{bn.balanced?}")
bn.rebalance
puts("balanced? : #{bn.balanced?}")
order_print(bn)

