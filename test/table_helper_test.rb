require File.dirname(__FILE__) + '/test_helper'

class TableizeHelperTest < Test::Unit::TestCase
  include Widgets
  
  EXPECTED_INSTANCE_METHODS = %w{tableize}
  
  def setup
    @view = ActionView::Base.new
    @view.extend ApplicationHelper
    @view.extend TableHelper
  end
  
  def test_presence_of_instance_methods
    EXPECTED_INSTANCE_METHODS.each do |instance_method|
      assert @view.respond_to?(instance_method), "#{instance_method} is not defined in #{@controller.inspect}" 
    end     
  end  
  
  def test_should_fail_if_wrong_args
    assert_raise(ArgumentError) do
      @view.tableize nil, nil
    end
    assert_raise(ArgumentError) do
      @view.tableize nil, []
    end
    assert_raise(ArgumentError) do
      @view.tableize 'main', nil
    end
    assert_raise(ArgumentError) do
      @view.tableize 'main', []
    end
    assert_raise(ArgumentError) do
      @view.tableize :the_name, [], :cols => 1 do
        # nothing
      end
    end
  end  
  
  def test_block_invariance
    _erbout = ''
    assert_nothing_raised do
      @view.tableize :the_name, ['IS', 'Same!', 'Thing?'] do |i|
        _erbout.concat i
      end
    end
    expected, _erbout = _erbout, ''
    assert_nothing_raised do
      @view.tableize(:the_name, ['IS', 'Same!', 'Thing?']) { |i| _erbout.concat i }
    end
    assert_dom_equal expected, _erbout, 'Block vs Proc generation differs'
  end   
  
  def test_empty_layout
    _erbout = ''
    @view.tableize :empty_layout, [], :cols => 2 do |i|
      _erbout.concat 'nowhere'
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table.empty_layout_table:root', :count => 1 do
      assert_select 'tr', :count => 1
      assert_select 'tr td', :count => 0
    end
  end  
  
  def test_1_item_layout
    _erbout = ''
    @view.tableize '1_item_layout', [1] do |i|
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table.1_item_layout_table:root', :count => 1 do
      assert_select 'tr', :count => 1
      assert_select 'tr:first-of-type td', :count => 3 do
        assert_select 'td:first-of-type', '1'
        assert_select 'td.blank:nth-of-type(2)', '&nbsp;'
        assert_select 'td.blank:last-of-type', '&nbsp;'
      end
    end
  end  
  
  def test_row_less_1_item_layout
    _erbout = ''
    @view.tableize 'row_less_1_item_layout', %w{1 2 3 4 5}, :cols => 6 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table.row_less_1_item_layout_table:root', :count => 1 do
      assert_select 'tr', :count => 1
      assert_select 'tr:first-of-type td', 6 do
        assert_select 'td:first-of-type', '1'
        assert_select 'td:nth-of-type(2)', '2'
        assert_select 'td:nth-of-type(3)', '3'
        assert_select 'td:nth-of-type(4)', '4'
        assert_select 'td:nth-of-type(5)', '5'
        assert_select 'td.blank:last-of-type', '&nbsp;'
      end
    end
  end  
  
  def test_full_row_layout
    _erbout = ''
    @view.tableize :full_row_layout, %w{1 2 3 4 5}, :cols => 5 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table.full_row_layout_table:root', :count => 1 do
      assert_select 'tr', :count => 1
      assert_select 'tr:first-of-type td', :count => 5 do
        assert_select 'td:first-of-type', '1'
        assert_select 'td:nth-of-type(2)', '2'
        assert_select 'td:nth-of-type(3)', '3'
        assert_select 'td:nth-of-type(4)', '4'
        assert_select 'td:last-of-type', '5'
      end
    end
  end  
  
  def test_row_plus_1_item_layout
    _erbout = ''
    @view.tableize 'row_plus_1_item_layout', %w{1 2 3 4 5}, :cols => 4 do |i| 
      _erbout.concat i.to_s
    end
    puts _erbout
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table.row_plus_1_item_layout_table:root', :count => 1 do
      assert_select 'tr', :count => 2
      assert_select 'tr:first-of-type td', :count => 4 do
        assert_select 'td:first-of-type', '1'
        assert_select 'td:nth-of-type(2)', '2'
        assert_select 'td:nth-of-type(3)', '3'
        assert_select 'td:last-of-type', '4'
      end
      assert_select 'tr:last-of-type td', :count => 4 do
        assert_select 'td:first-of-type', '5'
        assert_select 'td.blank:nth-of-type(2)', '&nbsp;'
        assert_select 'td.blank:nth-of-type(3)', '&nbsp;'
        assert_select 'td.blank:last-of-type', '&nbsp;'
      end
    end
  end  
  
  def test_options
    _erbout = ''
    @view.tableize 'options', %w{1 2 3 4 5}, 
    :generate_css => true,
    :header => 'TiTlE',
    :html => {:id => 'number', :class => 'demo'},
    :cols => 4 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, 'table[class=demo][id=number]:root', :count => 1 do
      assert_select 'tr', :count => 2
      assert_select 'tr:first-of-type th, tr:first-of-type td', :count => 4 do
        assert_select 'th:first-child', 'TiTlE'
        assert_select 'th:only-of-type', 'TiTlE'
        assert_select 'td:first-of-type', '1'
        assert_select 'td:nth-child(2)', '1'
        assert_select 'td:nth-of-type(2)', '2'
        assert_select 'td:last-of-type', '3'
        assert_select 'td:nth-child(4)', '3'
      end
      assert_select 'tr:last-of-type td', :count => 4 do
        assert_select 'td:first-of-type', '4'
        assert_select 'td:nth-of-type(2)', '5'
        assert_select 'td.blank:nth-of-type(3)', '&nbsp;'
        assert_select 'td.blank:last-of-type', '&nbsp;'
      end
    end
  end  
  
end