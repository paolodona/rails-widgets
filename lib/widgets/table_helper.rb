
module Widgets
  
  module TableHelper
    include CssTemplate
    
    # Returns an HTML table with +items+ disposend in rows. Add
    # HTML attributes by passing an attributes hash to +html_options+.
    # The content of each item is rendere using the given block.
    #
    # +:columns+ number of columns (default 3)
    # +:table_class+ css class for table
    # +:header_class+ css class of each headings
    # +:row_class+ css class of rows
    # +:data_class+ css class for non-empty cells
    # +:empty_class+ css class for all empty cells
    #
    #   <% tableize @users, :table_class => 'people', :columns => 2 do |user| -%>
    #     login: <%= user.name %>
    #   <% end -%>
    #    # => <table class="people"><tr><td>login: scooby</td><td>&nbsp;</td></tr></table>
    #
    def tableize(name, items, opts = {}, &block)
      raise ArgumentError, "Missing name parameter in tableize call" unless name
      raise ArgumentError, "Missing items parameter in tableize call" unless items
      raise ArgumentError, "Missing block in tableize call" unless block_given?
      columns = opts[:cols] || 3
      raise ArgumentError, "Tableize columns must be two or more" unless columns > 1
      
      @name = name || :main
      @generate_css = opts[:generate_css] || false
      html = opts[:html] || {} # setup default html options
      html[:id] ||= @name.to_s.underscore << '_table'
      html[:class] ||= html[:id]
      
      _out = generate_css? ? default_css : ''
      _out << tag('table', {:id => html[:id], :class => html[:class]}, true) 
      _out << tag('tr', nil, true)
      
      index = 0
      size = items.size
      # add header
      if (opts[:header]) 
        _out << content_tag('th', opts[:header])
        index += 1
        size += 1
      end
      # fill line with items, breaking if needed
      items.each do |item|
        index += 1
        _out << content_tag('td', capture(item, &block))
        _out << '</tr>' << tag('tr', nil, true) if index.remainder(columns) == 0 and index != size
      end
      # fill remaining columns with empty boxes
      remaining = size.remainder(columns)
       (columns - remaining).times do
        _out << content_tag('td', '&nbsp;', :class => 'blank') 
      end unless remaining == 0
      _out << '</tr>' << '</table>' 
      concat(_out, block.binding)
      nil # avoid duplication if called with <%= %>
    end
    
    private
    
    # return the name of the erb to parse for the default css generation
    def css_template_filename
      'table.css.erb' 
    end
  end
  
end