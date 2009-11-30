require File.dirname(__FILE__) + '/test_helper'
require 'test/unit'

# tableless model
class Post < ActiveRecord::Base
  def create_or_update
    errors.empty?
  end
    
  def self.columns()
    @columns ||= []
  end
      
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
end

class Widgets::ShowhideHelperTest < ActionView::TestCase
  attr_accessor :output_buffer
  include Widgets::ShowhideHelper
  
  def setup
    @params = {:html => {:id=>'custom_html_id', :class=>'custom_css_class'}, 
      :name => 'custom_name',
      :show_link_id => 'custom_show_link_id',
      :link_name => 'custom_link_name',
      :detail_box_id => 'custom_detail_box_id'}
    @post = Post.new
    @template = self
    clear_buffer
  end
    
  EXPECTED_INSTANCE_METHODS = %w{show_box_for detail_box_for hide_box_for}
  
  def test_presence_of_instance_methods
    EXPECTED_INSTANCE_METHODS.each do |instance_method|
      assert respond_to?(instance_method), "#{instance_method} is not defined after including the helper" 
    end     
  end    
  
  def test_show_box_for_with_defaults
    expected = "<a class=\"details_show_link\" href=\"#\" id=\"show_details_for_new_post\" onclick=\"$(&quot;details_for_new_post&quot;).show();\n$(&quot;show_details_for_new_post&quot;).hide();; return false;\">show details</a>"
    assert_equal expected, show_box_for(@post)
  
    @post[:id]=23
    expected = "<a class=\"details_show_link\" href=\"#\" id=\"show_details_for_post_23\" onclick=\"$(&quot;details_for_post_23&quot;).show();\n$(&quot;show_details_for_post_23&quot;).hide();; return false;\">show details</a>"
    assert_equal expected, show_box_for(@post)
  end
  
  def test_show_box_for_with_name
    expected = "<a class=\"happyness_show_link\" href=\"#\" id=\"show_happyness_for_new_post\" onclick=\"$(&quot;happyness_for_new_post&quot;).show();\n$(&quot;show_happyness_for_new_post&quot;).hide();; return false;\">show details</a>"  
    assert_equal expected, show_box_for(@post, :name=>'happyness')
  
    @post[:id]=23
    expected = "<a class=\"happyness_show_link\" href=\"#\" id=\"show_happyness_for_post_23\" onclick=\"$(&quot;happyness_for_post_23&quot;).show();\n$(&quot;show_happyness_for_post_23&quot;).hide();; return false;\">show details</a>"
    assert_equal expected, show_box_for(@post, :name=>'happyness')
  end
  
  def test_show_box_for_with_full_params
    expected = "<a class=\"custom_css_class\" href=\"#\" id=\"custom_html_id\" onclick=\"$(&quot;custom_detail_box_id&quot;).show();\n$(&quot;custom_html_id&quot;).hide();; return false;\">custom_link_name</a>"
    assert_equal expected, show_box_for(@post, @params.merge(:name=>'must_be_overrided'))
  end
  
  def test_show_box_if_not_ar
    expected = "<a class=\"details_show_link\" href=\"#\" id=\"show_details_for_my_wonderful-name\" onclick=\"$(&quot;details_for_my_wonderful-name&quot;).show();\n$(&quot;show_details_for_my_wonderful-name&quot;).hide();; return false;\">show details</a>"
    assert_equal expected, show_box_for('my_wonderful-name')
  end
  
  ## hide
  
  def test_hide_box_for_with_defaults
    expected = "<a class=\"details_hide_link\" href=\"#\" id=\"hide_details_for_new_post\" onclick=\"$(&quot;details_for_new_post&quot;).hide();\n$(&quot;show_details_for_new_post&quot;).show();; return false;\">hide details</a>"
    assert_equal expected, hide_box_for(@post)
  
    @post[:id]=54
    expected = "<a class=\"details_hide_link\" href=\"#\" id=\"hide_details_for_post_54\" onclick=\"$(&quot;details_for_post_54&quot;).hide();\n$(&quot;show_details_for_post_54&quot;).show();; return false;\">hide details</a>"
    assert_equal expected, hide_box_for(@post)
  end
  
  def test_hide_box_for_with_name
    expected = "<a class=\"fear_hide_link\" href=\"#\" id=\"hide_fear_for_new_post\" onclick=\"$(&quot;fear_for_new_post&quot;).hide();\n$(&quot;show_fear_for_new_post&quot;).show();; return false;\">hide details</a>"
    assert_equal expected, hide_box_for(@post, :name=>'fear')
  
    @post[:id]=54
    expected = "<a class=\"fear_hide_link\" href=\"#\" id=\"hide_fear_for_post_54\" onclick=\"$(&quot;fear_for_post_54&quot;).hide();\n$(&quot;show_fear_for_post_54&quot;).show();; return false;\">hide details</a>"
    assert_equal expected, hide_box_for(@post, :name=>'fear')
  end
  
  def test_hide_box_for_with_full_params
    expected = "<a class=\"custom_css_class\" href=\"#\" id=\"custom_html_id\" onclick=\"$(&quot;custom_detail_box_id&quot;).hide();\n$(&quot;custom_show_link_id&quot;).show();; return false;\">custom_link_name</a>"
    assert_equal expected, hide_box_for(@post, @params.merge(:name=>'must_be_overrided'))
  end  
  
  def test_hide_box_if_non_ar
    expected = "<a class=\"details_hide_link\" href=\"#\" id=\"hide_details_for_my_wonderful-name\" onclick=\"$(&quot;details_for_my_wonderful-name&quot;).hide();\n$(&quot;show_details_for_my_wonderful-name&quot;).show();; return false;\">hide details</a>"
    assert_equal expected, hide_box_for('my_wonderful-name')
  end
  
  ## detail
  
  def test_detail_box_should_raise_argument_error
    assert_raise(ArgumentError) do
      detail_box_for @post
    end
  end
    
  def test_detail_box_css_generation
    expected = "<style>\n  .details_for_post {\n    background: #FFFABF;\n    border: solid 1px #cccccc;\n    padding: 10px;\n    margin-bottom: 5px;\n  }\n</style>\n"+
      "<div class=\"details_for_post\" id=\"details_for_new_post\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for @post, :generate_css=>true do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  end
  
  def test_detail_box_with_defaults
    expected = "<div class=\"details_for_post\" id=\"details_for_new_post\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for @post do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  
    @post[:id]=87
    expected = "<div class=\"details_for_post\" id=\"details_for_post_87\" style=\"display:none;\">nice Content</div>"
    clear_buffer
    
    assert_nothing_raised do
      detail_box_for @post do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  end
  
  def test_detail_box_with_name
    expected = "<div class=\"master_for_post\" id=\"master_for_new_post\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for @post, :name=>'master' do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  
    @post[:id]=87
    clear_buffer
    expected = "<div class=\"master_for_post\" id=\"master_for_post_87\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for @post, :name=>'master' do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  end
  
  def test_detail_box_with_full_params
    expected = "<div class=\"custom_css_class\" id=\"custom_html_id\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for @post, @params.merge(:name=>'must_be_overrided') do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  end
  
  def test_detail_box_if_not_ar
    expected = "<div class=\"details_for_my_wonderful-name\" id=\"details_for_my_wonderful-name\" style=\"display:none;\">nice Content</div>"
    assert_nothing_raised do
      detail_box_for 'my_wonderful-name' do
        output_buffer.concat 'nice Content'
      end
    end
    assert_equal expected, output_buffer
  end
  
  protected
  
  def clear_buffer
    @output_buffer = ''
  end
    
end
