module Taka
  class MutationEvent < Event
    MODIFICATION = 1
    ADDITION     = 2
    REMOVAL      = 3

    attr_accessor :relatedNode, :prevValue, :newValue, :attrName, :attrChange

    def initMutationEvent(type, canBubble, cancelable, relatedNode, prevValue, newValue, attrName, attrChange)
      raise(NotImplementedError.new("not implemented: #{self.class.name}#initMutationEvent"))
    end

    def initMutationEventNS(namespaceURI, type, canBubble, cancelable, relatedNode, prevValue, newValue, attrName, attrChange)
      raise(NotImplementedError.new("not implemented: #{self.class.name}#initMutationEventNS"))
    end
  end
end