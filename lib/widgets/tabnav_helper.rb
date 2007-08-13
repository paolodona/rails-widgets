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
      render_default_tabnav_css if @_tabnav.generate_css?  
      concat(tag('div',@_tabnav.html ,true), @_binding)
      tabnav_tabs 
      concat('</div>', @_binding)
      nil
    end 
  
    # adds the content div
    def start_tabnav(name, opts={}, &proc)
      raise ArgumentError, "Missing name parameter in start_tabnav call" unless name
      raise ArgumentError, "Missing block in start_tabnav call" unless block_given?
      tabnav(name, opts, &proc) 
      concat "\n", @_binding
      options = {:id => @_tabnav.html[:id] + '_content', :class => @_tabnav.html[:class] + '_content'}
      concat( tag('div', options, true), @_binding)
      nil
    end
 
    def end_tabnav
      concat "</div>", @_binding
      nil
    end
  
    def add_tab options = {}
      raise 'Cannot call add_tab outside of a tabnav or start_tabnav block' unless @_tabnav
      @_tabnav.tabs << Tab.new(options)
    end
 
    private 
     
    # renders the tabnav's tabs
    def tabnav_tabs
      concat(tag('ul', {} , true), @_binding)
    
      @_tabnav.tabs.each do |tab|      
        tab.html[:class] = 'active' if tab.highlighted?(params)
        tab.html[:title] = tab.title if tab.title
           
        li_options = tab.html[:id] ? {:id => tab.html[:id] + '_container'} : {} 
        concat(tag('li', li_options, true), @_binding)
        if tab.link.empty?
          concat(content_tag('span', tab.name, tab.html), @_binding) 
        else
          concat(link_to(tab.name, tab.link, tab.html), @_binding)
        end
        concat "</li> \n", @_binding 
      end 
      concat('</ul>', @_binding)
    end  
    
    # render the inline css
    def render_default_tabnav_css  
      concat @_tabnav.default_css, @_binding
    end
    
  end
end