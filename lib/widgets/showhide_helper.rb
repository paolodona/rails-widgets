module Widgets
  module ShowhideHelper
    include CssTemplate

    def show_box_for record, opts={}
      name = opts[:name] || 'details'
      link_name = opts[:link_name] || 'show details'
      detail_box_id = opts[:detail_box_id] || dom_detail_id(record,name)

      html = opts[:html] || {} # setup default html options
      html[:id] ||= dom_show_id(record,name)
      html[:class] ||= "#{name}_show_link"

      link_to_function link_name, nil, html do |page|
        page[detail_box_id].show
        page[html[:id]].hide
      end
    end

    def hide_box_for record, opts={}
      name = opts[:name] || 'details'
      link_name = opts[:link_name] || 'hide details'
      detail_box_id = opts[:detail_box_id] || dom_detail_id(record,name)
      show_link_id = opts[:show_link_id] || dom_show_id(record,name)

      html = opts[:html] || {} # setup default html options
      html[:id] ||= dom_hide_id(record,name)
      html[:class] ||= "#{name}_hide_link"

      link_to_function link_name, nil, html do |page|
        page[detail_box_id].hide
        page[show_link_id].show
      end
    end

    def detail_box_for record, opts={}, &block
      raise ArgumentError, 'Missing block in showhide.detail_box_for call' unless block_given?
      name = opts[:name] || 'details'
      @generate_css = opts[:generate_css] || false

      html = opts[:html] || {} # setup default html options
      html[:id] ||= dom_detail_id(record,name)
      html[:class] ||= "#{name}_for_#{normalize_class_name(record)}"
      html[:style] = 'display:none;'
      @css_class = html[:class]
      concat(render_css('showhide'), block.binding) if generate_css?
      # Taken from ActionView::Helpers::RecordTagHelper
      concat content_tag(:div, capture(&block), html), block.binding
      nil
    end

    private

    def dom_detail_id record, name
      normalize_dom_id(record, name.to_s)
    end

    def dom_show_id record, name
      normalize_dom_id(record, "show_#{name}")
    end

    def dom_hide_id record, name
      normalize_dom_id(record, "hide_#{name}")
    end

    def normalize_dom_id object, prefix
      if object.kind_of?(ActiveRecord::Base)
        dom_id(object, "#{prefix}_for#{object.id ? '' : '_new'}")
      else
        [ prefix, 'for', normalize_class_name(object) ].compact * '_'
      end
    end

    def normalize_class_name object
      if object.kind_of?(ActiveRecord::Base)
        ActionController::RecordIdentifier.singular_class_name(object)
      else
        object.to_s
      end
    end

    # content_tag_for creates an HTML element with id and class parameters
    # that relate to the specified Active Record object.
    #
    # Taken from ActionView::Helpers::RecordTagHelper
    def content_box_for(tag_name, *args, &block)
      concat content_tag(tag_name, capture(&block), args), block.binding
    end
  end
end
