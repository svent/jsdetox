module Taka
  module DOM
    class NodeList
      def initialize &block
        @block = block
      end

      def [](key)
        @block.call[key]
      end

      def length
        @block.call.count
      end

      def item(index)
        @block.call[index]
      end

      # apparently can run into an endless loop
      # def respond_to? name
      #   @block.call.respond_to?(name)
      # end

      def method_missing name, *args, &block
        @block.call.send(name, *args, &block)
      end

      # def js_property?(name)
      #   [:length].include?(name)
      # end
    end
  end
end
