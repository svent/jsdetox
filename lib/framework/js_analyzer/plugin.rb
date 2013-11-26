module JSDetox
module JSAnalyzer
module Plugins

class Plugin
  def self.handle(node_class)
    PluginManager.register_plugin(self, node_class)
  end
end

end
end
end
