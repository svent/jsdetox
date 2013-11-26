#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class UnaryOperations < Plugin
  handle BitwiseNotNode
  handle UnaryMinusNode

  def self.optimize(node, level)
    if node.is_a?(RKelly::Nodes::BitwiseNotNode) && node.value.is_a?(RKelly::Nodes::NumberNode)
      newval = ~node.value.value
      res = RKelly::Nodes::NumberNode.new(newval)
      node.newvalue = res
      return res
    end

    if node.is_a?(RKelly::Nodes::UnaryMinusNode) && node.value.is_a?(RKelly::Nodes::NumberNode)
      newval = -node.value.value
      res = RKelly::Nodes::NumberNode.new(newval)
      node.newvalue = res
      return res
    end
  end
end

end
end
end
