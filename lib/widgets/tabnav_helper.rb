module Widgets
  module TabnavHelper  
    protected 
    
    # renders the tabnav
    def tabnav(name, opts={}, &proc)
      raise ArgumentError, "Missing name parameter in tabnav call" unless name
      raise ArgumentError, "Missing block in tabnav call" unless block_given?
      @_tabnav = Tabnav.new(name, opts)
      @_binding = proc.binding # the binding of calling page
  
      instance_eval(&proc) 
      out @_tabnav.default_css if @_tabnav.generate_css?  
      out tag('div',@_tabnav.html ,true)
      render_tabnav_tabs 
      out '</div>'
      nil
    end 
  
    # adds the content div
    def start_tabnav(name, opts={}, &proc)
      raise ArgumentError, "Missing name parameter in start_tabnav call" unless name
      raise ArgumentError, "Missing block in start_tabnav call" unless block_given?
      tabnav(name, opts, &proc) 
      out "\n"
      options = {:id => @_tabnav.html[:id] + '_content', :class => @_tabnav.html[:class] + '_content'}
      out tag('div', options, true)
      nil
    end
 
    def end_tabnav
      out '</div>'
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