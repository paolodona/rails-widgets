
module Widgets
  
  module TableHelper
    include CssTemplate
    
    # Returns an HTML table with +:collection+ disposed in rows. Add
    # HTML attributes by passing an attributes hash to +html+.
    # The content of each item is rendered using the given block.
    #
    # +:collection+ array of items
    # +:cols+ number of columns (default 3)
    # +:html+ table html attributes (+:class+, +:id+)
    # +:name+ name of table (dafault +:main+)
    #
    #   <% tableize @users, :name => 'credential', :html => {:class => 'people'}, :cols => 2 do |user| -%>
    #     login: <%= user.name %>
    #   <% end -%>
    #
    #    # => <table id="credential_table" class="people"><tbody><tr>
    #           <td>login: scooby</td><td>&nbsp;</td>
    #         </tr></tbody></table>
    #
    def tableize(collection = nil, opts = {}, &block)
      table = Tableizer.new(collection, opts, self, &block)
      table.render
    end
    
    class Tableizer
      
      def initialize(collection, opts, template, &block)
        parse_args(collection, opts, template, &block)
        
        raise ArgumentError, 'Missing collection parameter in tableize call' unless @collection
        raise ArgumentError, 'Missing block in tableize call' unless block_given?
        raise ArgumentError, 'Tableize columns must be two or more' unless @columns >= 2
      end
      
      def render
        generate_css
        generate_html
        concat(@output_buffer)
        nil # avoid duplication if called with <%= %>
      end
      
      protected
      
      def parse_args(collection, opts, template, &block)
        @collection = collection
        @collection ||= opts[:collection]
        
        @columns = opts[:cols] || 3
        
        @generate_css = opts[:generate_css] || false
        
        @name = opts[:name] || :main
        @html = opts[:html] || {} # setup default html options
        @html[:id] ||= @name.to_s.underscore << '_table'
        @html[:class] ||= @html[:id]
        @header = opts[:header]
        @skip_header_column = opts[:skip_header_column]
        
        @template = template
        @block = block
        
        @output_buffer = ''
      end
      
      def generate_css
        @output_buffer << render_css('table') if generate_css?
      end
      
      def generate_html
        @output_buffer << tag('table', {:id => @html[:id], :class => @html[:class]}, true) 
        @output_buffer << tag('tbody', nil, true) 
        @output_buffer << tag('tr', nil, true)

        index = 0
        size = @collection.size
        empty_cell = content_tag('td', '&nbsp;', :class => 'blank')
        # add header
        if (@header) 
          @output_buffer << content_tag('th', @header)
          index += 1
          size += 1
        end
        # fill line with items, breaking if needed
        @collection.each do |item|
          index += 1
          @output_buffer << content_tag('td', capture(item, &@block))

          should_wrap = ( index.remainder(@columns) == 0 and index != size )
          @output_buffer << '</tr>' << tag('tr', nil, true) if should_wrap 

          # prepend every line with an empty cell
          if should_wrap && @skip_header_column == true
            @output_buffer << empty_cell 
            index += 1; size += 1
          end
        end
        # fill remaining columns with empty boxes
        remaining = size.remainder(@columns)
         (@columns - remaining).times do
          @output_buffer << empty_cell
        end unless remaining == 0
        @output_buffer << '</tr>' << '</tbody>' << '</table>'
      end
      
      def generate_css?
        @generate_css
      end
      
      def method_missing(*args, &block)
        @template.send(*args, &block)
      end
    end
    
  end
  
end
