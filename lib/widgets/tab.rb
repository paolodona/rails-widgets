module Widgets
  class Tab
    include Highlightable
    attr_accessor :link, :name, :html
    
    def initialize(opts={})
      @name = opts[:name] 
      @link = opts[:link] || {}
      
      # wrap highlights into an array if only one hash has been passed
      opts[:highlights] = [opts[:highlights]] if opts[:highlights].kind_of?(Hash)
      self.highlights = opts[:highlights] || []
      @html = opts[:html] || {} 
      @html[:title] = opts[:title] 
     
      yield(self) if block_given?
      
      self.highlights << @link if link? # it does highlight on itself
      raise ArgumentError, 'you must provide a name' unless @name
    end
    
    # title is a shortcut to html[:title]
    def title; @html[:title]; end
    def title=(new_title); @html[:title]=new_title; end
    
    # more idiomatic ways to set tab properties
    def links_to(l); @link = l; end
    def named(n); @name = n; end
    def titled(t); @html[:title] = t; end
    
    def link?
      @link && !@link.empty?
    end
       
  end
end
