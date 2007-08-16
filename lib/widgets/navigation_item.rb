module Widgets
  class NavigationItem
    include Highlightable
    
    attr_accessor :name, :link, :html
    
    def initialize(opts={})
      @name = opts[:name] 
      @link = opts[:link] || {}
      @html = opts[:html] || {} 
      @html[:title] = opts[:title] 
     
      yield(self) if block_given?
      
      highlights << @link if link? # it does highlight on itself
      raise ArgumentError, 'you must provide a name' unless @name
    end
       
    def link?
      @link && !@link.empty?
    end
         
  end
end