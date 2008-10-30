module Widgets
  module ProgressbarHelper  
    include CssTemplate
    
    # show a progressbar
    #
    # eg: <%= progressbar 35, :generate_css => true %>
    # or  <%= progressbar [35,78,15] %>
    #
    # options
    # ===
    #   :generate_css defaults to false 
    #   :adjust       defaults to false
    def progressbar values, options={}
      raise ArgumentError, "Missing value(s) parameter in progressbar call" unless values
      raise ArgumentError, "The value parameter has to be a Numeric o Array" unless values.kind_of?(Array) or values.kind_of?(Numeric)
      if values.kind_of? Numeric # single value
        total = 100 
        values = [values]
      else # Array of values
        total = values.sum
      end 

      html = ""
      html << render_css('progressbar') if options[:generate_css] == true
      html << '<div class="progressbar">'          
      values.dup.each_with_index do |value, index|
        if total == 0
          percentage = 0
        else
          percentage = options[:adjust] ? (value * 100 / total) : value
        end 
        css_class = "progressbar_color_#{index.modulo(10)}"
        html << "<div style='width: #{percentage}%;' class='#{css_class}'></div>"
      end 
      html << "</div>" 
    end
  end
end
