module Taka
  module DOM
    module DTD
      def entities
        entities = super
        entities.extend(DOM::NamedNodeMap)
        entities.document ||= document
        entities
      end

      def attributes
        nil
      end

      def notations
        notations = super
        notations.extend(DOM::NamedNodeMap)
        notations.document ||= document
        notations
      end

      def elements
        elements = super
        elements.extend(DOM::NamedNodeMap)
        elements.document ||= document
        elements
      end
    end
  end
end
