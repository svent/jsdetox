module Taka
  class DOMException < StandardError
    NOEXCEPTION_ERR             = 0
    INDEX_SIZE_ERR              = 1
    DOMSTRING_SIZE_ERR          = 2
    HIERARCHY_REQUEST_ERR       = 3
    WRONG_DOCUMENT_ERR          = 4
    INVALID_CHARACTER_ERR       = 5
    NO_DATA_ALLOWED_ERR         = 6
    NO_MODIFICATION_ALLOWED_ERR = 7
    NOT_FOUND_ERR               = 8
    NOT_SUPPORTED_ERR           = 9
    INUSE_ATTRIBUTE_ERR         = 10
    INVALID_STATE_ERR           = 11
    SYNTAX_ERR                  = 12
    INVALID_MODIFICATION_ERR    = 13
    NAMESPACE_ERR               = 14
    INVALID_ACCESS_ERR          = 15
    NULL_POINTER_ERR            = 100

    attr_accessor :code

    def initialize code, message = nil
      @code = code
      super(message)
    end
  end
end
