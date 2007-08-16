require File.dirname(__FILE__) + '/test_helper'

class NavigationHelperTest < Test::Unit::TestCase
  attr_accessor :params
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include Widgets::NavigationHelper
  
  def setup
    @params = {}
  end
    
  def test_presence_of_instance_methods
    %w{navigation add_item}.each do |instance_method|
      assert respond_to?(instance_method), "#{instance_method} is not defined after including the helper" 
    end     
  end    
  
  def test_empty
    expected = <<-END
      <div class="navigation" id="navigation"></div>
    END
    
    _erbout = ''
    navigation do; end# do nothing
    assert_equal expected.strip, _erbout;
  end
  
  def test_two_items
    expected = <<-END
      <div class="navigation" id="navigation"><ul>
          <li><a href="http://www.seesaw.it">seesaw</a>&nbsp;|&nbsp;</li>
          <li><a href="http://blog.seesaw.it">blog</a></li>
        </ul>
      </div>
    END
    
    _erbout = ''
    navigation do
      add_item :name => 'seesaw', :link => 'http://www.seesaw.it'
      add_item :name => 'blog', :link => 'http://blog.seesaw.it'
    end
    
    assert_dom_equal expected, _erbout;
  end
  
end