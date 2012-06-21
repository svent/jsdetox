module Taka
  module DOM
    module CharacterData
      def data
        content
      end

      def data=(_)
        raise(NotImplementedError.new("not implemented: #{self.class.name}#data="))
      end

      def length
        content.length
      end

      def substringData offset, count
        if offset > length || offset < 0 || count < 0
          raise DOMException.new(DOMException::INDEX_SIZE_ERR)
        end
        content[offset, count]
      end

      def appendData data
        self.content = "#{content}#{data}"
      end

      def insertData offset, arg
        if offset < 0 || offset > length
          raise DOMException.new(DOMException::INDEX_SIZE_ERR)
        end
        copy = content
        copy.insert(offset, arg)
        self.content = copy
      end

      def deleteData offset, count
        if offset < 0 || count < 0 || offset > length
          raise DOMException.new(DOMException::INDEX_SIZE_ERR)
        end
        replaceData(offset, count, '')
      end

      def replaceData offset, count, arg
        if offset < 0 || count < 0 || offset > length
          raise DOMException.new(DOMException::INDEX_SIZE_ERR)
        end
        copy = content
        copy[offset, count] = arg
        self.content = copy
      end

      def nodeName
        '#cdata-section'
      end
    end
  end
end
