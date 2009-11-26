#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'

class SpiffyCornersHelperTest < ActionView::TestCase

  attr_accessor :params
  include Widgets::SpiffyCorners::SpiffyCornersHelper
  
  def setup
    @params = {}
  end
    
  def test_simple_with_css
    expected = load_template('spiffy_corners/simple.html') 
    
    spiffy_corners(:generate_css => true) do concat("Ciccio"); end
    assert_equal expected, output_buffer
  end
end
