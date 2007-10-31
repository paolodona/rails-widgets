
module Widgets
  
  module TableHelper
    include CssTemplate
    
    # Returns an HTML table with +:collection+ disposed in rows. Add
    # HTML attributes by passing an attributes hash to +html+.
    # The content of each item is rendere using the given block.
    #
    # +:collection+ array of items
    # +:cols+ number of columns (default 3)
    # +:html+ table html attributes (+:class+, +:id+)
    # +:table_name+ name of table (dafault +:main+)
    #
    #   <% tableize 'credential', @users, :html => {:class => 'people'}, :cols => 2 do |user| -%>
    #     login: <%= user.name %>
    #   <% end -%>
    #
    #    # => <table id="credential_table" class="people"><tbody><tr>
    #           <td>login: scooby</td><td>&nbsp;</td>
    #         </tr></tbody></table>
    #
    def tableize(collection = nil, opts = {}, &block)
      collection ||= opts[:collection]
      raise ArgumentError, 'Missing collection parameter in tableize call' unless collection
      raise ArgumentError, 'Missing block in tableize call' unless block_given?
      columns = opts[:cols] || 3
      raise ArgumentError, 'Tableize columns must be two or more' unless columns > 1
      
      @generate_css = opts[:generate_css] || false
      @name = opts[:name] || :main
      html = opts[:html] || {} # setup default html options
      html[:id] ||= @name.to_s.underscore << '_table'
      html[:class] ||= html[:id]
      
      _out = generate_css? ? default_css : ''
      _out << tag('table', {:id => html[:id], :class => html[:class]}, true) 
      _out << tag('tbody', nil, true) 
      _out << tag('tr', nil, true)
      
      index = 0
      size = collection.size
      # add header
      if (opts[:header]) 
        _out << content_tag('th', opts[:header])
        index += 1
        size += 1
      end
      # fill line with items, breaking if needed
      collection.each do |item|
        index += 1
        _out << content_tag('td', capture(item, &block))
        _out << '</tr>' << tag('tr', nil, true) if index.remainder(columns) == 0 and index != size
      end
      # fill remaining columns with empty boxes
      remaining = size.remainder(columns)
       (columns - remaining).times do
        _out << content_tag('td', '&nbsp;', :class => 'blank') 
      end unless remaining == 0
      _out << '</tr>' << '</tbody>' << '</table>' 
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