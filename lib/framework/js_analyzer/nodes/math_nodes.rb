#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class LeftShiftNodes < Plugin
  handle LeftShiftNode

  def self.optimize(node, level)
    if node.is_a?(RKelly::Nodes::LeftShiftNode) && node.left.is_a?(RKelly::Nodes::NumberNode) && node.value.is_a?(RKelly::Nodes::NumberNode)
      newval = node.left.value << node.value.value
      res = RKelly::Nodes::NumberNode.new(newval)
      node.newvalue = res
      return res
    end
  end
end

end
end
end
