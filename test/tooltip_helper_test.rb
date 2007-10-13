require File.dirname(__FILE__) + '/test_helper'

class TooltipHelperTest < Test::Unit::TestCase
  attr_accessor :params
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper
  include Widgets::TooltipHelper
  
  def setup
    @params = {}
  end
    
  def test_presence_of_instance_methods
    %w{tooltip}.each do |instance_method|
      assert respond_to?(instance_method), "#{instance_method} is not defined after including the helper" 
    end     
  end    
  
  def test_tooltip_link_function
    expected = "$('one_tooltip_link').observe('click', function(event){toggleTooltip(event, $('one_tooltip'))});"   
    assert_equal expected.strip, tooltip_link_function(:one);
  
    expected = "$('two_tooltip_link').observe('click', function(event){toggleTooltip(event, $('two_tooltip'))});"   
    assert_equal expected.strip, tooltip_link_function(:two);
  end
  
  def test_close_tooltip_link
    expected = "<a href=\"#\" onclick=\"$('first_tooltip').hide(); return false;\">close</a>"   
    assert_equal expected.strip, close_tooltip_link(:first);
    
    expected = "<a href=\"#\" onclick=\"$('second_tooltip').hide(); return false;\">chiudi</a>"   
    assert_equal expected.strip, close_tooltip_link(:second, 'chiudi');
  end
 
end