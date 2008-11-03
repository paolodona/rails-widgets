#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'

class SpiffyCornersHelperTest < Test::Unit::TestCase
  attr_accessor :params
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::CaptureHelper
  include Widgets::SpiffyCorners::SpiffyCornersHelper
  
  def setup
    @params = {}
  end
    
  def test_simple_with_css
    expected = load_template('spiffy_corners/simple.html') 
    
    _erbout = ''
    spiffy_corners(:generate_css => true) do concat("Ciccio", binding); end
    assert_equal expected, _erbout
  end
end
