module ActionView
  module Helpers
    module AssetTagHelper
      
      # We redefine javascript_include_tag in order to auto-magically include
      # the widgets javascripts. If you hame more than one javascript_include_tag
      # call, the widgets javascripts gets included only once.
      def javascript_include_tag_with_widgets(*sources)
        unless @__widgets_has_already_included_its_js
          options = sources.last.is_a?(Hash) ? sources.pop : {} # remove options
          sources << 'widgets/tooltip'
          sources << options # add previously removed option
          @__widgets_has_already_included_its_js = true
        end 
        javascript_include_tag_without_widgets(*sources)
      end
      alias_method_chain :javascript_include_tag, :widgets 
    end
  end
end