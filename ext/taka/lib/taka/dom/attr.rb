module Taka
  module DOM
    module Attr
      attr_accessor :ownerElement

      def specified
        !!ownerElement[self.name]
      end

      def parentNode
        nil
      end

      def attributes
        nil
      end

      def nextSibling 
        nil
      end
    end
  end
end
