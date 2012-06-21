module Taka
  module DOM
    module Notation
      def publicId
        public_id
      end

      def systemId
        system_id
      end

      def nodeName
        name
      end

      def nodeValue
        nil
      end

      def nodeValue= value
      end

      def nodeType
        12
      end

      def attributes
        nil
      end
    end
  end
end
