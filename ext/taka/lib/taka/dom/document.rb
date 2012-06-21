module Taka
  module DOM
    module Document
      def getElementsByTagName name
        DOM::NodeList.new do
          css(name)
        end
      end

      def getElementById id_name
        css("##{id_name}").first
      end

      def doctype
        internal_subset
      end

      def implementation
        raise(NotImplementedError.new("not implemented: #{self.class.name}#implementation"))
      end

      def documentElement
        root
      end

      def attributes
        nil
      end

      def createElement tag_name
        unless tag_name =~ /^\w+$/
          raise Taka::DOMException.new(Taka::DOMException::INVALID_CHARACTER_ERR)
        end
        Nokogiri::XML::Node.new(tag_name, self)
      end

      def createDocumentFragment
        Nokogiri::XML::DocumentFragment.new(self)
      end

      def createTextNode data
        Nokogiri::XML::Text.new(data, self)
      end

      def createComment(data)
        Nokogiri::XML::Comment.new(self, data)
      end

      def createCDATASection(data)
        Nokogiri::XML::CDATA.new(self, data)
      end

      def createProcessingInstruction(target, data)
        Nokogiri::XML::ProcessingInstruction.new(self, target, data)
      end

      def createAttribute name
        unless name =~ /^\w+$/
          raise DOMException.new(DOMException::INVALID_CHARACTER_ERR)
        end
        Nokogiri::XML::Attr.new(self, name)
      end

      def createEntityReference name
        unless name =~ /^\w+$/
          raise DOMException.new(DOMException::INVALID_CHARACTER_ERR)
        end
        Nokogiri::XML::EntityReference.new(self, name)
      end

      def getImplementation
        self
      end

      def hasFeature type, version
        return true if type.downcase == 'xml'
      end

      def importNode(importedNode, deep)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#importNode"))
      end

      def createElementNS(namespaceURI, qualifiedName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#createElementNS"))
      end

      def createAttributeNS(namespaceURI, qualifiedName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#createAttributeNS"))
      end

      def getElementsByTagNameNS(namespaceURI, localName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#getElementsByTagNameNS"))
      end

      def inputEncoding
        raise(NotImplementedError.new("not implemented: #{self.class.name}#inputEncoding"))
      end

      def xmlEncoding
        raise(NotImplementedError.new("not implemented: #{self.class.name}#xmlEncoding"))
      end

      def xmlStandalone
        raise(NotImplementedError.new("not implemented: #{self.class.name}#xmlStandalone"))
      end

      def xmlStandalone=(_)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#xmlStandalone="))
      end

      def xmlVersion
        raise(NotImplementedError.new("not implemented: #{self.class.name}#xmlVersion"))
      end

      def xmlVersion=(_)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#xmlVersion="))
      end

      def strictErrorChecking
        raise(NotImplementedError.new("not implemented: #{self.class.name}#strictErrorChecking"))
      end

      def strictErrorChecking=(_)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#strictErrorChecking="))
      end

      def documentURI
        @document_uri
      end
      
      def documentURI=(uri)
        @document_uri = uri
      end
      
      def adoptNode(source)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#adoptNode"))
      end

      def domConfig
        raise(NotImplementedError.new("not implemented: #{self.class.name}#domConfig"))
      end

      def normalizeDocument
        raise(NotImplementedError.new("not implemented: #{self.class.name}#normalizeDocument"))
      end

      def renameNode(n, namespaceURI, qualifiedName)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#renameNode"))
      end

      def decorate node
        nx = Nokogiri::XML
        nh = Nokogiri::HTML
        map = {
          nx::Node     => [DOM::Element, DOM::Node],
          nx::Element  => [DOM::Element, DOM::Node],
          nx::Attr     => [DOM::Element, DOM::Node, DOM::Attr],
          nx::NodeSet  => [DOM::NodeSet],
          nx::Text     => [DOM::Element, DOM::Node, DOM::CharacterData, DOM::Text],
          nx::CDATA    => [DOM::Element, DOM::Node, DOM::Text, DOM::CharacterData],
          nx::ProcessingInstruction => [DOM::Element, DOM::Node, DOM::ProcessingInstruction],
          nx::EntityDecl => [DOM::Element, DOM::Node, DOM::EntityDecl],
          nx::EntityReference => [DOM::Element, DOM::Node, DOM::EntityReference],
          nx::DTD     => [DOM::Element, DOM::Node, DOM::DTD],
          nx::DocumentFragment => [DOM::Element, DOM::Node, DOM::DocumentFragment],
          nx::Comment => [DOM::Element, DOM::Node, DOM::Comment],
          nx::Notation => [DOM::Element, DOM::Node, DOM::Notation],
          nh::DocumentFragment => [DOM::Element, DOM::Node, DOM::DocumentFragment]
        }
        # map[nh::DocumentFragment] = map[nx::DocumentFragment]
        list = map[node.class]

        raise("Unknown type #{node.class.name}") unless list

        list.each { |mod| node.extend(mod) }
        node
      end

      # def js_property? name
      #   [:body, :documentElement, :nodeName].include?(name)
      # end
    end
  end
end
