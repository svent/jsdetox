module Taka
  module DOM
    module AttrNodeMap
      include NamedNodeMap
      
      attr_accessor :ownerElement
      
      # def createAttribute name
      #   Nokogiri::XML::Attr.new(document, name)
      # end
      #
      # def getNamedItem name
      #   item = self[name] || createAttribute(name)
      #   item.ownerElement = self
      #   document.decorate(item)
      # end
      
      def setNamedItem item
        if item.ownerElement && item.ownerElement != self.ownerElement
          raise DOMException.new(DOMException::INUSE_ATTRIBUTE_ERR)
        end
        super
      end
    end
  end
end
