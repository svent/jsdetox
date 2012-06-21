module Taka
  class MouseEvent < Event
    attr_accessor :screenX, :screenY, :clientX, :clientY, :ctrlKey, :shiftKey,
      :altKey, :metaKey, :button, :relatedTarget

    def initMouseEvent(type, canBubble, cancelable, view, detail, screenX, screenY, 
      clientX, clientY, ctrlKey, altKey, shiftKey, metaKey, button, relatedTarget)
      raise(NotImplementedError.new("not implemented: #{self.class.name}#initMouseEvent"))
    end

    def getModifierState(keyIdentifier)
      raise(NotImplementedError.new("not implemented: #{self.class.name}#getModifierState"))
    end

    def initMouseEventNS(namespaceURI, type, canBubble, cancelable, view, detail, 
      screenX, screenY, clientX, clientY, button, relatedTarget, modifiersList)
      raise(NotImplementedError.new("not implemented: #{self.class.name}#initMouseEventNS"))
    end
  end
end