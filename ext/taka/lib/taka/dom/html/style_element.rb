module Taka
  module DOM
    module HTML
      module StyleElement
        attr_accessor :disabled

        class << self
          def extended style
            style.disabled = false
          end
        end

        def type
          self['type']
        end
      end
    end
  end
end
