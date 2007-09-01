
module Widgets
  
  module TableHelper
    
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
    def tableize(items, html_options = {}, &block)
      raise ArgumentError, "Missing items parameter in tableize call" unless items
      raise ArgumentError, "Missing block in tableize call" unless block_given?
      columns = html_options[:columns] || 3
      raise ArgumentError, "Tableize columns must be two or more" unless columns > 1
      table_options = { :class => html_options[:table_class] } if html_options.has_key?(:table_class)
      th_options = { :class => html_options[:header_class] } if html_options.has_key?(:header_class)
      tr_options = { :class => html_options[:row_class] } if html_options.has_key?(:row_class)
      td_options = { :class => html_options[:data_class] } if html_options.has_key?(:data_class)
      empty_options = { :class => html_options[:empty_class] } if html_options.has_key?(:empty_class)
      
      html = tag('table', table_options, true) << tag('tr', tr_options, true)
      # fill line with items, breaking if needed
      index = 0
      items.each do |item|
        index += 1
        html << content_tag('td', capture(item, &block),  td_options)
        html << '</tr>' << tag('tr', tr_options, true) if index.remainder(columns) == 0 and index != items.size
      end
      # fill remaining columns with empty boxes
      remaining = items.size.remainder(columns)
      (columns - remaining).times do
        html << content_tag('td', '&nbsp;', empty_options) 
      end unless remaining == 0
      html << '</tr>' << '</table>' 
      concat(html, block.binding)
      nil # avoid duplication if called with <%= %>
    end
    
  end
  
end