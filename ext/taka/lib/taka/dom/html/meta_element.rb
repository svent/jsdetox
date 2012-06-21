module Taka
  module DOM
    module HTML
      module MetaElement
        def content
          self['content']
        end

        def httpEquiv
          self['http-equiv']
        end

        def name
          self['name']
        end
      end
    end
  end
end
