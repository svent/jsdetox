module Taka
  module DOM
    module Element
      def tagName
        self.name
      end

      def getAttribute(name)
        self[name].to_s
      end

      def setAttribute(name, value)
        if read_only? || [
          Node::TEXT_NODE,
          Node::ENTITY_DECL
        ].include?(nodeType)
          raise DOMException.new(DOMException::NO_MODIFICATION_ALLOWED_ERR)
        end

        if name.length == 0 || name !~ /^\w+$/
          raise DOMException.new(DOMException::INVALID_CHARACTER_ERR)
        end
        self[name] = value
      end

      def removeAttribute(name)
        if read_only?
          raise DOMException.new(DOMException::NO_MODIFICATION_ALLOWED_ERR)
        end
        self.remove_attribute(name)
      end

      def getAttributeNode name
        attribute = self.attribute(name)
        attribute.ownerElement = self if attribute
        attribute
      end

      def setAttributeNode new_attribute
        if read_only? || [
          Node::TEXT_NODE,
          Node::ENTITY_DECL
        ].include?(nodeType)
          raise DOMException.new(DOMException::NO_MODIFICATION_ALLOWED_ERR)
        end

        if new_attribute.ownerElement && new_attribute.ownerElement != self
          raise DOMException.new(DOMException::INUSE_ATTRIBUTE_ERR)
        end
        new_attribute.ownerElement = self

        if new_attribute.document != self.document
          raise DOMException.new(DOMException::WRONG_DOCUMENT_ERR)
        end

        if self[new_attribute.name] == new_attribute.value
          new_attribute
        else
          old_attribute = self.getAttributeNode(new_attribute.name)
          old_attribute = old_attribute.dup(1) if old_attribute.respond_to?(:value)
          self[new_attribute.name] = new_attribute.value
          old_attribute
        end
      end

      def removeAttributeNode old_attribute
        if old_attribute.ownerElement != self
          raise DOMException.new(DOMException::NOT_FOUND_ERR)
        end
        remove_attribute old_attribute.name
      end

      def getElementsByTagName(name)
        DOM::NodeList.new do
          css(name)
        end
      end

      def getAttributeNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#getAttributeNS"))
      end

      def setAttributeNS(namespaceURI, qualifiedName, value)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#setAttributeNS"))
      end

      def removeAttributeNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#removeAttributeNS"))
      end

      def getAttributeNodeNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#getAttributeNodeNS"))
      end

      def setAttributeNodeNS(newAttr)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#setAttributeNodeNS"))
      end

      def getElementsByTagNameNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#getElementsByTagNameNS"))
      end

      def hasAttribute(name)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#hasAttribute"))
      end

      def hasAttributeNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#hasAttributeNS"))
      end
    end
  end
end
