module Taka
  module DOM
    module Document
      # interface DocumentEvent {
      #   Event createEvent(in DOMString eventType) raises(DOMException);
      # };
      # DOMException NOT_SUPPORTED_ERR: Raised if the implementation does not
      # support the type of Event interface requested
      def createEvent(type)
        if type.nil? || !Event::TYPES.include?(type)
          raise EventException.new(EventException::NOT_SUPPORTED_ERR)
        end

        Event.new(type)
      end
    end
  end
end