module Taka
  module DOM
    module ProcessingInstruction
      def attributes
        nil
      end

      def target
        name
      end

      def data
        content
      end
    end
  end
end
