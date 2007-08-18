module Widgets
  module TabnavHelper  
    protected 
    
    # main methods
    
    # eg: <% start_tabnav :main do %>
    #      ...html...
    #     <% end %>
    def tabnav name
      render :partial => "gm/widgets/#{name}_tabnav" 
      if block_given?
        options = {:id => @_tabnav.html[:id] + '_content', :class => @_tabnav.html[:class] + '_content'}
        out tag('div', options, true)
        yield
        out '</div>'
      end
    end
    
    # tabnav building methods
    # they are used inside the widgets/*_tabnav.rhtml partials 
    # (you can also call them in your views if you want)
    
    # renders the tabnav
    def render_tabnav(name, opts={}, &proc)
      raise ArgumentError, "Missing name parameter in tabnav call" unless name
      raise ArgumentError, "Missing block in tabnav call" unless block_given?
      @_tabnav = Tabnav.new(name, opts)
      @_binding = proc.binding # the binding of calling page
  
      instance_eval(&proc) 
      out @_tabnav.default_css if @_tabnav.generate_css?  
      out tag('div',@_tabnav.html ,true)
      render_tabnav_tabs 
      out "</div>\n"
      nil
    end 
  
    def add_tab options = {}, &block
      raise 'Cannot call add_tab outside of a tabnav or start_tabnav block' unless @_tabnav
      @_tabnav.tabs << Tab.new(options, &block)
    end
 
    private 
     
    # renders the tabnav's tabs
    def render_tabnav_tabs
      out tag('ul', {} , true)
    
      @_tabnav.tabs.each do |tab|      
        tab.html[:class] = 'active' if tab.highlighted?(params)
            
        li_options = tab.html[:id] ? {:id => tab.html[:id] + '_container'} : {} 
        out tag('li', li_options, true)
        if tab.link.empty?
          out content_tag('span', tab.name, tab.html) 
        else
          out link_to(tab.name, tab.link, tab.html)
        end
        out "</li> \n"
      end 
      out '</ul>'
    end  
     
    def out(string); concat string, @_binding; end
  end
end