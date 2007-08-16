module Widgets 
  class Navigation
    attr_accessor :items, :html, :separator
    include CssTemplate
    
    def initialize(opts={})
      @items = []
      @generate_css = opts[:generate_css] || false
      @html = opts[:html] || {} # setup default html options
      @html[:id] ||= 'navigation'
      @html[:class] ||= @html[:id]
      @separator = opts[:separator] ||= '&nbsp;|&nbsp;'
    end
    
    def add_item opts={}
      @items ||= []
      @items << NavigationItem.new(opts)
    end
  
  end
end