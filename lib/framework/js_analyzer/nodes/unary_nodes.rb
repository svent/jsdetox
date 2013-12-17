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

class IncrementDecrementOperations < Plugin
  handle PrefixNode
  handle PostfixNode

  def self.optimize(node, level, var_store, sen)
    if (node.is_a?(PrefixNode) || node.is_a?(PostfixNode)) && node.value.is_a?(String) && (node.value == '++' || node.value == '--') && node.operand.is_a?(ResolveNode)
      var_name = node.operand.value
      var_value = var_store.resolve(level, var_name, sen)
      if var_value.is_a?(NumberNode)
        oldval = var_value.value
        if node.value == '++'
          newval = var_value.value + 1
        elsif node.value == '--'
          newval = var_value.value - 1
        end
        var_store.set_var(level, var_name, RKelly::Nodes::NumberNode.new(newval), sen, node)
        if node.class == PostfixNode
          res = RKelly::Nodes::NumberNode.new(oldval)
        else
          res = RKelly::Nodes::NumberNode.new(newval)
        end
        node.newvalue = res
        return res
      end
    end
  end
end

end
end
end
