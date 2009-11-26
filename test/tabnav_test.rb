require File.dirname(__FILE__) + '/test_helper'

class TabnavTest < ActionView::TestCase

  include Widgets::TabnavHelper
  attr_accessor :params

  def setup
    @params = {}
  end

  def test_default_html_options
    tabnav = Widgets::Tabnav.new :sample
    assert_equal 'sample_tabnav', tabnav.html[:id]
    assert_equal 'sample_tabnav', tabnav.html[:class]
  end

  def test_multiple_css_class
    render_tabnav :main do
      add_tab :html=>{:class=>'home'} do |t|
        t.named 'active-tab'
        t.links_to 'my/demo/link'
        t.highlight!
      end
      add_tab :html=>{:class=>'custom'} do |t|
        t.named 'second'
      end
      add_tab do |t|
        t.named 'middle'
      end
      add_tab :html=>{:class=>'last'} do |t|
        t.named 'disabled-tab'
        t.disable!
      end
    end

    root = HTML::Document.new(output_buffer).root
    assert_select root, 'div[class=main_tabnav][id=main_tabnav]:root', :count => 1 do
      assert_select 'ul:only-of-type li', :count => 4 do
        assert_select 'li[class=home active]:first-of-type' do
          assert_select 'a[class=home active]:only-of-type', 'active-tab'
        end
        assert_select 'li.custom:nth-of-type(2)', 'second'
        assert_select 'li:nth-of-type(3)', 'middle'
        assert_select 'li[class=last disabled]:last-of-type' do
          assert_select 'span[class=last disabled]:only-of-type', 'disabled-tab'
        end
      end
    end
  end
end
