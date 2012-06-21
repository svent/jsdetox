module Taka
  module DOM
    module EntityDecl
      def attributes
        nil
      end

      def publicId
        external_id
      end

      def systemId
        system_id
      end

      def notationName
        content # naming? passes test_entitygetpublicid.rb though
      end
    end
  end
end
