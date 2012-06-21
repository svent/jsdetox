module Taka
  module DOM
    module DocumentFragment
      def self.parse(*args)
        fragment = Nokogiri::HTML::DocumentFragment.parse(*args)
        fragment.extend(DOM::Element)
        fragment.extend(DOM::Node)
        fragment.extend(DOM::DocumentFragment)
        fragment.extend(Module.new {
          def decorate node
            node = super

            if node.is_a?(Nokogiri::XML::NodeSet)
              node.extend(DOM::HTML::Collection)
              return node
            end

            node.extend(DOM::HTML::Element)
            ({
              'table'     => [DOM::HTML::TableElement],
              'tr'        => [DOM::HTML::TableRowElement],
              'thead'     => [DOM::HTML::TableSectionElement],
              'tfoot'     => [DOM::HTML::TableSectionElement],
              'tbody'     => [DOM::HTML::TableSectionElement],
              'a'         => [DOM::HTML::AnchorElement],
              'applet'    => [DOM::HTML::AppletElement],
              'area'      => [DOM::HTML::AreaElement],
              'body'      => [DOM::HTML::BodyElement],
              'form'      => [DOM::HTML::FormElement],
              'button'    => [DOM::HTML::ButtonElement],
              'select'    => [DOM::HTML::SelectElement],
              'fieldset'  => [DOM::HTML::FieldSetElement],
              'frame'     => [DOM::HTML::FrameElement],
              'iframe'    => [DOM::HTML::IFrameElement],
              'img'       => [DOM::HTML::ImageElement],
              'input'     => [DOM::HTML::InputElement],
              'isindex'   => [DOM::HTML::IsIndexElement],
              'label'     => [DOM::HTML::LabelElement],
              'legend'    => [DOM::HTML::LegendElement],
              'li'        => [DOM::HTML::LiElement],
              'link'      => [DOM::HTML::LinkElement],
              'map'       => [DOM::HTML::MapElement],
              'meta'      => [DOM::HTML::MetaElement],
              'object'    => [DOM::HTML::ObjectElement],
              'ol'        => [DOM::HTML::OListElement],
              'option'    => [DOM::HTML::OptionElement],
              'param'     => [DOM::HTML::ParamElement],
              'pre'       => [DOM::HTML::PreElement],
              'script'    => [DOM::HTML::ScriptElement],
              'style'     => [DOM::HTML::StyleElement],
              'th'        => [DOM::HTML::TableCellElement],
              'td'        => [DOM::HTML::TableCellElement],
              'col'       => [DOM::HTML::ColElement],
              'colgroup'  => [DOM::HTML::ColElement],
              'textarea'  => [DOM::HTML::TextAreaElement],
              'ul'        => [DOM::HTML::UListElement],
            }[node.node_name] || []).each do |klass|
              node.extend(klass)
            end

            node
          end
        })
        fragment
      end
      
      
      def attributes
        nil
      end

      def nodeName
        '#document-fragment'
      end
    end
  end
end
