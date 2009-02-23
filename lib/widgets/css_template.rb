module Widgets
  # Utility module for widgets that need to create a default CSS
  # you have to include it inside a Widget to add css_generation capability
  module CssTemplate
    
    def render_css(name)
      @_widgets_css_templates ||= {}
      return @_widgets_css_templates[name] if @_widgets_css_templates[name] # return the cached copy if possible
      # if not cached read and evaluate the template
      css_template_filename = "#{name}.css.erb" 
      css_template = ERB.new IO.read(File.join(File.dirname(__FILE__), css_template_filename))
      @_widgets_css_templates[name] = css_template.result(binding)
    end 
    
    # WD-rpw 02-22-2009 changed name to not conflict with ruby/gems/1.8/gems/actionpack-1.13.3/lib/action_view/base.rb's render_template method
    def rw_render_template(name, _binding = nil)
      _template_filename = "#{name}.html.erb" 
      _template = ERB.new IO.read(File.join(File.dirname(__FILE__), _template_filename))
      _template.result(binding)
    end

    # should the helper generate a css for this widget?
    def generate_css?
      @generate_css ? true : false
    end
    
  end
end
