module Widgets
  module NavigationHelper

    def navigation name, opts={}
      partial_template = opts[:partial] || "widgets/#{name}_navigation"
      html = capture { render :partial => partial_template }
      return html
    end

    def render_navigation(name=:main, opts={}, &proc)
      raise ArgumentError, "Missing name parameter in render_navigation call" unless name
      raise ArgumentError, "Missing block in render_navigation call" unless block_given?
      @_navigation = Navigation.new(name, opts)
      instance_eval(&proc)
      concat @_navigation.render_css('navigation') if @_navigation.generate_css?
      concat tag('div',@_navigation.html ,true)
      render_navigation_items
      concat '</div>'
      nil
    end

    def add_item opts = {}, &block
      raise 'Cannot call add_item outside of a render_navigation block' unless @_navigation
      @_navigation.items << NavigationItem.new(opts,&block)
      nil
    end

    private

    def render_navigation_items
      return if @_navigation.items.empty?

      concat "<ul>\n"
      @_navigation.items.each_with_index do |item,index|
        if item.disabled?
          item.html[:class] = 'disabled'
        elsif item.highlighted?(params)
          item.html[:class] = 'active'
        end

        concat '<li>'
        if item.disabled?
          concat content_tag('span', item.name, item.html)
        else
          if !item.function.blank?
            concat link_to_function(item.name, item.function, item.html)
          else
            concat link_to(item.name, item.link, item.html)
          end
        end
        concat @_navigation.separator unless index == @_navigation.items.size - 1
        concat "</li>\n"
      end
      concat '</ul>'
    end
  end
end

