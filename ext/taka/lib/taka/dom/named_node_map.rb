module Taka
  module DOM
    module NamedNodeMap
      attr_accessor :document

      def getNamedItem name
        item = self[name]
        return item unless item
        document.decorate(item)
      end

      def removeNamedItem name
        unless key? name
          raise DOMException.new(DOMException::NOT_FOUND_ERR)
        end
        delete name
      end

      def setNamedItem item
        if document != item.document
          raise DOMException.new(DOMException::WRONG_DOCUMENT_ERR)
        end

        return_item = getNamedItem(item.name)

        self[item.name] = item
        return_item
      end

      def item index
        getNamedItem(self.keys[index])
      end
    end
  end
end
