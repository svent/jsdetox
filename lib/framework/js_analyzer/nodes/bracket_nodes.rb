#!/usr/bin/env ruby

module JSDetox
module JSAnalyzer
module Plugins

class BracketNodes < Plugin
  handle BracketAccessorNode

  def self.optimize(node, level)

    if node.is_a?(BracketAccessorNode) && node.value.is_a?(StringNode) && node.accessor.is_a?(StringNode) then
      value = node.value.value.gsub(/^['"]?|['"]?$/, "")
      accessor = node.accessor.value.gsub(/^['"]?|['"]?$/, "")
      if accessor == "length"
        node.newvalue = NumberNode.new(value.length)
      end
    end

  end
end


end
end
end
