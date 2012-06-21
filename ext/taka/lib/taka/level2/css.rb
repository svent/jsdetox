# CSSStyleDeclaration

module Taka
  class CSSStyleDeclaration
  end

  module ElementCSSInlineStyle
    def style
      @style ||= CSSStyleDeclaration.new
    end
  end
end

Taka::DOM::HTML::Element.send(:include, Taka::ElementCSSInlineStyle)