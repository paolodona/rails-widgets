module Widgets 
  class Tabnav 
    include CssTemplate
    attr_accessor :tabs, :html, :name
        
    def initialize(name, opts={})
      @name = name || :main
      @tabs = []
      @generate_css = opts[:generate_css] || false
      @html = opts[:html] || {} # setup default html options
      @html[:id] ||= name.to_s.underscore << '_tabnav'
      @html[:class] ||= @html[:id]
    end
     
    # should the helper generate a css for this tabnav?
    def generate_css?
      @generate_css ? true : false
    end
   
    # sort your tabs alphabetically
    def sort!
      @tabs.sort! { |x,y| x.name <=> y.name  }
    end
    
  end
end
