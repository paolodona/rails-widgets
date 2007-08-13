module Widgets 
  class Tabnav 
    attr_accessor :tabs, :html, :name
    attr_reader :default_css
    @@css_template = ERB.new IO.read(File.expand_path(File.dirname(__FILE__) + "/tabnav.css.erb"))
       
    def initialize(name, opts={})
      @name = name || :main
      @tabs = []
      @generate_css = opts[:generate_css] || false
      @html = opts[:html] || {} # setup default html options
      @html[:id] ||= name.to_s.underscore << '_tabnav'
      @html[:class] ||= @html[:id]
    end
    
    def default_css
      @default_css if @default_css
      # build it and cache it
      @default_css = @@css_template.result(binding)
    end
    
    # should the helper generate a css for this tabnav?
    def generate_css?
      @generate_css ? true : false
    end
  end
end