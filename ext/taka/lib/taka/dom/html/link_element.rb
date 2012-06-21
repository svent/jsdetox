module Taka
  module DOM
    module HTML
      module LinkElement
        def disabled
          !!self['disabled']
        end

        def type
          self['type']
        end
      end
    end
  end
end
