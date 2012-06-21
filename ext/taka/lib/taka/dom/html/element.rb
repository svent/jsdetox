module Taka
  module DOM
    module HTML
      module Element
        def []=(key, value)
          case value
          when NilClass, FalseClass
            value = ''
          when TrueClass
            value = key
          # when Fixnum
          #   value = value.to_s
          end
          super
        end

        def id
          getAttribute('id')
        end

        def className
          self['className']
        end

        ###
        # NOT part of W3C DOM spec.
        # http://developer.mozilla.org/en/DOM/element.innerHTML
        def innerHTML
          inner_html
        end

        def innerHTML=(html)
					children.each do |child|
						child.remove
					end
          document.fragment(html).children.each do |tag|
            appendChild(tag)
            document.decorate(tag)
          end
        end

        def method_missing method, *args, &block
          attribute = method.to_s.downcase
          super unless key?(attribute)
          self[attribute]
        end
      end
    end
  end
end
