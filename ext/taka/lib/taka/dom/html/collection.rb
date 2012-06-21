module Taka
  module DOM
    module HTML
      module Collection
        def namedItem name
          find { |item|
            item.id == name
          } || find { |item|
            item.name == name
          }
        end
      end
    end
  end
end
