module Widgets
  module TooltipHelper
    include CssTemplate
    
    def tooltip(name=nil, opts={}, &proc)
      opts[:id] ||= rand(1000)
      name ||= image_tag('widgets/tooltip_image.gif', :border => 0)
      @_binding = proc.binding

      out default_css unless @_tooltip_css_done
      @_tooltip_css_done = true
      
      out tooltip_link(opts[:id],name)
      out javascript_tag(tooltip_link_function(opts[:id]))
      out render_tooltip(name, capture(&proc), opts)
      nil
    end
       
    def tooltip_link(id, name)
      link_to name, '#', :id => "#{id}_tooltip_link"
    end
    
    def tooltip_link_function(id)
      "$('#{id}_tooltip_link').observe('click', function(event){toggleTooltip(event, $('#{id}_tooltip'))});"
    end
 
    def close_tooltip_link(id, message)
      message ||= 'close'
      link_to_function message, "$('#{id}_tooltip').hide()"
    end
    
    def render_tooltip(name, content, opts)
      html = tag('div', {:id => "#{opts[:id]}_tooltip", :class=>'tooltip', :style => 'display:none'}, true)
      html << tag('div', {:id => "#{opts[:id]}_tooltip_content", :class=>'tooltip_content'},true)
      html << content
      html << '<small>' + close_tooltip_link(opts[:id], opts[:close_message]) + '</small>'     
      html << '</div></div>' 
      html
    end
    
    # return the name of the erb to parse for the default css generation
    def css_template_filename
      'tooltip.css.erb' 
    end
    
  end
end
