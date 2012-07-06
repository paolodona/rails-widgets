module Widgets
  module TooltipHelper
    include CssTemplate
    
    def tooltip(name=nil, opts={}, &proc)
      if name.kind_of?(Hash) # called like this: <%= tooltip :name => 'aaa', :partial => 'mytooltip' %>
        opts = name
        name = opts[:name]
      end
      
      opts[:id] ||= rand(1000)
      name ||= image_tag('widgets/tooltip_image.gif', :border => 0)
 
      result = ''.html_safe
      result << tooltip_css.html_safe
      result << tooltip_link(opts[:id],name).html_safe
      result << javascript_tag(tooltip_link_function(opts[:id])).html_safe
      result << render_tooltip(name, tooltip_content(opts,&proc), opts).html_safe
      
      if block_given?
        safe_concat result.html_safe
        return nil
      else
        return result.html_safe
      end
    end
    
    def tooltip_css
      unless @_tooltip_css_done
        @_tooltip_css_done = true
        return render_css('tooltip')
      else
        ''
      end
    end
    
    def tooltip_content(opts={}, &proc)
     return render(:partial => opts[:partial]) if opts[:partial]
     return capture(&proc)
    end
       
    def tooltip_link(id, name)
      link_to name, 'javascript:void(0)', :id => "tooltip_link_#{id}"
    end
    
    def tooltip_link_function(id)
      "$('tooltip_link_#{id}').observe('click', function(event){toggleTooltip(event, $('tooltip_#{id}'))});".html_safe
    end
 
    def close_tooltip_link(id, message = 'close'.html_safe)
      message ||= 'close'.html_safe # if nil is passed I'll force it
      link_to_function message, "$('tooltip_#{id}').hide()".html_safe
    end
    
    def render_tooltip(name, content, opts)
      html = tag('div', {:id => "tooltip_#{opts[:id]}", :class=>'tooltip', :style => 'display:none'}, true).html_safe
      html << tag('div', {:id => "tooltip_content_#{opts[:id]}", :class=>'tooltip_content'},true).html_safe
      html << content.html_safe
      html << '<small>'.html_safe + close_tooltip_link(opts[:id], opts[:close_message]) + '</small>'.html_safe     
      html << '</div></div>'.html_safe 
      html.html_safe
    end
  end
end
