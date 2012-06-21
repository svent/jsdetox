module Taka
  module DOM
    module Text
      def attributes
        nil
      end

      def nodeName
        '#text'
      end

      def splitText index
        if index < 0 || index > length
          raise DOMException.new(DOMException::INDEX_SIZE_ERR)
        end
        left = text[0..(index - 1)]
        right = text[index..-1]
        self.content = left

        right = document.createTextNode right
        # parent.insertBefore(right, nextSibling) if parent # apparently text nodes get joined?
        right
      end
    end
  end
end
