module Widgets
  module NavigationHelper
    
    def navigation name 
      html = capture { render :partial => "widgets/#{name}_navigation" }
      return html
    end
    
    def render_navigation(opts={}, &proc)
      @_navigation = Navigation.new(opts)
      @_binding = proc.binding # the binding of calling page
      instance_eval(&proc) 
      out @_navigation.default_css if @_navigation.generate_css?  
      out tag('div',@_navigation.html ,true)
      render_navigation_items
      out '</div>'
      nil
    end 
    
    def add_item opts = {}
      @_navigation.add_item opts
      nil
    end
       
    private 
    
    def render_navigation_items
      return if @_navigation.items.empty?
      
      out "<ul>\n"
      @_navigation.items.each_with_index do |item,index|
        item.html[:class] = 'active' if item.highlighted?(params)
        out '<li>' 
        out link_to(item.name, item.link, item.html)
        out @_navigation.separator unless index == @_navigation.items.size - 1
        out "</li>\n"
      end
      out '</ul>'
    end
   
    def out(string); concat string, @_binding; end
    
  end
end
