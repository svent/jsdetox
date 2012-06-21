module Taka
  module EventTarget
    def addEventListener(type, listener, use_capture = false)
      listeners = self.listeners(type, use_capture)
      listeners << listener unless listeners.include?(listener)
    end

    def removeEventListener(type, listener, use_capture = false)
      listeners = self.listeners(type, use_capture)
      listeners.delete(listener)
    end

    def dispatchEvent(event)
      raise 'event can not be nil' if event.nil? # TODO what's a better exception?
      if event.type.nil? || event.type.to_s.empty?
        raise Taka::EventException.new(Taka::EventException::UNSPECIFIED_EVENT_TYPE_ERR)
      end
      
      event.target = self
      capture_event(event)
      dispatch_event(Event::AT_TARGET, event)
      evaluate_event_attribute(event)
      bubble_event(event) if event.bubbles
      execute_default_behaviour unless event.cancelled
      
      event.cancelled
    end

    protected
    
      def capture_event(event)
        ancestors.reverse.dup.each do |ancestor| 
          ancestor.dispatch_event(Event::CAPTURING_PHASE, event)
          break if event.propagation_stopped
        end if respond_to?(:ancestors)
      end
      
      def bubble_event(event)
        ancestors.dup.each do |node| 
          node.dispatch_event(Event::BUBBLING_PHASE, event)
          break if event.propagation_stopped
        end if respond_to?(:ancestors)
      end

      def dispatch_event(phase, event)
        return if event.propagation_stopped

        event.eventPhase = phase
        event.currentTarget = self
        
        listeners(event.type, event.eventPhase == Event::CAPTURING_PHASE).dup.each do |listener|
          event.stopPropagation unless call_listener(listener, event)
        end
      end
      
      def call_listener(listener, event)
        # https://developer.mozilla.org/en/DOM/element.addEventListener
        # [listener] must be an object implementing the EventListener interface, or simply a JavaScript function.
        listener.respond_to?(:handleEvent) ? listener.handleEvent(event) : listener.call(event)
      end
      
      def evaluate_event_attribute(event)
        evaluate_js(self["on#{event.type}"]) if respond_to?(:[]) && self["on#{event.type}"]
      end
      
      def execute_default_behaviour
        # TODO
      end

      def listeners(type, use_capture)
        phase = use_capture ? Event::CAPTURING_PHASE : Event::BUBBLING_PHASE
        @listeners ||= {}
        @listeners[type] ||= {}
        @listeners[type][phase] ||= []
      end
  end
end