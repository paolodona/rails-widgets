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
      @view.tableize nil
    end
    assert_raise(ArgumentError) do
      @view.tableize []
    end
    assert_raise(ArgumentError) do
      @view.tableize [], :columns => 1 do
        # nothing
      end
    end
  end  
  
  def test_block_invariance
    _erbout = ''
    assert_nothing_raised do
      @view.tableize ['IS', 'Same!', 'Thing?'], :columns => 2 do |i|
        _erbout.concat i
      end
    end
    expected, _erbout = _erbout, ''
    assert_nothing_raised do
      @view.tableize(['IS', 'Same!', 'Thing?'], :columns => 2) { |i| _erbout.concat i }
    end
    assert_dom_equal expected, _erbout, "Block vs Proc generation differs"
  end   
  
  def test_empty_layout
    _erbout = ''
    @view.tableize [] do |i|
      _erbout.concat 'nowhere'
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, "table:root", 1 do
      assert_select "tr", 1
      assert_select "tr td", 0
    end
  end  
  
  def test_one_item_layout
    _erbout = ''
    @view.tableize [1], :table_class => 'demo', :columns => 3 do |i|
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, "table.demo:root", 1 do
      assert_select "tr", 1
      assert_select "tr:first-of-type td", 3 do
        assert_select "td:first-of-type", '1'
        assert_select "td:nth-of-type(2)", '&nbsp;'
        assert_select "td:last-of-type", '&nbsp;'
      end
    end
  end  
  
  def test_row_less_1_item_layout
    _erbout = ''
    @view.tableize %w{1 2 3 4 5}, :table_class => 'demo', :columns => 6 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, "table.demo:root", 1 do
      assert_select "tr", 1
      assert_select "tr:first-of-type td", 6 do
        assert_select "td:first-of-type", '1'
        assert_select "td:nth-of-type(2)", '2'
        assert_select "td:nth-of-type(3)", '3'
        assert_select "td:nth-of-type(4)", '4'
        assert_select "td:nth-of-type(5)", '5'
        assert_select "td:last-of-type", '&nbsp;'
      end
    end
  end  
  
  def test_full_row_layout
    _erbout = ''
    @view.tableize %w{1 2 3 4 5}, :table_class => 'demo', :columns => 5 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, "table.demo:root", 1 do
      assert_select "tr", 1
      assert_select "tr:first-of-type td", 5 do
        assert_select "td:first-of-type", '1'
        assert_select "td:nth-of-type(2)", '2'
        assert_select "td:nth-of-type(3)", '3'
        assert_select "td:nth-of-type(4)", '4'
        assert_select "td:last-of-type", '5'
      end
    end
  end  
  
  def test_row_plus_1_item_layout
    _erbout = ''
    @view.tableize %w{1 2 3 4 5}, :table_class => 'demo', :columns => 4 do |i| 
      _erbout.concat i.to_s
    end
    root = HTML::Document.new(_erbout).root
    assert_select root, "table.demo:root", 1 do
      assert_select "tr", 2
      assert_select "tr:first-of-type td", 4 do
        assert_select "td:first-of-type", '1'
        assert_select "td:nth-of-type(2)", '2'
        assert_select "td:nth-of-type(3)", '3'
        assert_select "td:last-of-type", '4'
      end
      assert_select "tr:last-of-type td", 4 do
        assert_select "td:first-of-type", '5'
        assert_select "td:nth-of-type(2)", '&nbsp;'
        assert_select "td:nth-of-type(3)", '&nbsp;'
        assert_select "td:last-of-type", '&nbsp;'
      end
    end
  end  
  
end