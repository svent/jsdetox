module Taka
  module DOM
    module HTML
      module TableElement
        def rows
          DOM::NodeList.new {
            xpath('./thead/tr', './tbody/tr', './tr', './tfoot/tr')
          }
        end

        def insertRow index
          tr = Nokogiri::XML::Node.new('tr', self.document)

          sibling = rows[index] || rows.last

          if rows.length == 0
            add_child Nokogiri::XML::Node.new('tbody', document)
          end

          if !sibling
            self.add_child tr
          else
            sibling.add_previous_sibling tr
          end
          tr
        end

        def deleteRow index
          (row = rows[index]) && row.unlink
        end

        def caption
          at('./caption')
        end

        def tHead
          at('./thead')
        end

        def tFoot
          at('./tfoot')
        end

        def tBodies
          xpath('./tbody')
        end

        def createTHead
          head = tHead
          return head if head
          head = Nokogiri::XML::Node.new('thead', document)
          add_child head
        end

        def deleteTHead
          head = tHead
          head.unlink if head
          nil
        end

        def createTFoot
          return self.tFoot if tFoot
          foot = Nokogiri::XML::Node.new('tfoot', document)
          add_child foot
          foot
        end

        def deleteTFoot
          tFoot.unlink if tFoot
          nil
        end

        def createCaption
          return self.caption if caption
          my_caption = Nokogiri::XML::Node.new('caption', document)
          add_child my_caption
          my_caption
        end

        def deleteCaption
          caption.unlink if caption
          nil
        end
      end
    end
  end
end
