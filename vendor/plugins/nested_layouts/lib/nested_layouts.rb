module ActionView #:nodoc:
  module Helpers #:nodoc:
    module NestedLayoutsHelper
      # Wrap part of the template into layout.
      #
      # If layout doesn't contain '/' then corresponding layout template
      # is searched in default folder ('app/views/layouts'), otherwise
      # it is searched relative to controller's template root directory
      # ('app/views/' by default).
      def inside_layout(layout, &block)
        layout = layout.include?('/') ? layout : "layouts/#{layout}"
        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat(
          @template.render( :file => layout, :user_full_path => true ),
          block.binding
        )
      end

      # Wrap part of the template into inline layout.
      # Same as +inside_layout+ but takes layout template content rather than layout template name.
      def inside_inline_layout(template_content, &block)
        @template.instance_variable_set('@content_for_layout', capture(&block))
        concat( @template.render( :inline => template_content ), block.binding )
      end
    end
  end
end
