module Taka
  class EventException < StandardError
    NOT_SUPPORTED_ERR          = 0
    UNSPECIFIED_EVENT_TYPE_ERR = 1

    attr_accessor :code

    def initialize code, message = nil
      @code = code
      super(message)
    end
  end
end
