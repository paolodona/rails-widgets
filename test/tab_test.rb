require File.dirname(__FILE__) + '/test_helper'

class TabTest < Test::Unit::TestCase
  include Widgets
  
  EXPECTED_INSTANCE_METHODS = %w{highlights link name title html highlighted? highlights_on}
  
  def setup    
    @myname = 'Paolo'
    @mysurname = 'Dona'
   
    @tab = Tab.new :name => 'tab', :link => {:controller => 'pippo', :action => 'pluto'}
    @simple_tab = Tab.new :name => 'simple_tab', :link => {:controller =>'pippo'}
    @dyntab = Tab.new :name => @myname, 
                      :link => {:controller => 'pippo', :action => @myname},
                      :highlights => [{:controller => @mysurname}]
    
    @empty = Tab.new :name => 'empty'
  end
     
  def test_initialize_with_hash
    tab = Tab.new :name => 'sample'
    assert tab
    assert_equal 'sample', tab.name
  end
  
  def test_initialize_with_block
    tab = Tab.new do |t|
      t.name = 'sample'
    end
    assert tab
    assert_equal 'sample', tab.name
  end
    
  def test_presence_of_instance_methods
    EXPECTED_INSTANCE_METHODS.each do |instance_method|
      assert @tab.respond_to?(instance_method), "#{instance_method} is not defined in #{@tab.inspect} (#{@tab.class})" 
    end     
  end
  
  def test_name_dynamic
    assert_equal 'Paolo', @dyntab.name
   
    @dyntab.name= @mysurname 
    assert_equal 'Dona', @dyntab.name
  end
  
  def test_links_to
    assert_equal({:controller => 'pippo', :action => 'pluto'}, @tab.link)
    
    @tab.link= {:controller => 'pluto'}
    assert_equal({:controller => 'pluto'}, @tab.link)
  end
  
  def test_links_to_dynamic
    assert_equal({:controller => 'pippo', :action => 'Paolo'}, @dyntab.link)
    
    @dyntab.link= {:controller => @mysurname}  
    assert_equal({:controller => 'Dona'}, @dyntab.link)
  end
  
  def test_highlights_on
    assert_equal [], @empty.highlights, 'should return an empty array'
    @empty.highlights=[ {:action => 'my_action'}, {:action => 'my_action2', :controller => 'my_controller'}]
    assert @empty.highlights.kind_of?(Array)
    assert_equal 2, @empty.highlights.size, '2 highlights were added so far'
    
    @empty.highlights.each {|hl| assert hl.kind_of?(Hash)}
    
    # sanity check
    assert_equal 'my_action', @empty.highlights[0][:action] 
  end
  
  def test_highlights_on_dynamic 
    assert_equal 2, @dyntab.highlights.size, 'should return 2 elements'
    @dyntab.highlights_on :action=> @mysurname
    @dyntab.highlights_on :name => @myname, :surname => @mysurname
     
    assert @dyntab.highlighted?({:action => 'Dona'})
    assert @dyntab.highlighted?({:name => 'Paolo', :surname => 'Dona'})
    assert @dyntab.highlighted?({:controller => 'pippo', :action => 'Paolo'})
    assert @dyntab.highlighted?({:controller => 'Dona'})
  end
  
  def test_highlighted 
    #check that highlights on its own link
    assert @simple_tab.highlighted?(:controller => 'pippo'), 'should highlight'
    assert @simple_tab.highlighted?(:controller => 'pippo', :action => 'list'),'should highlight'
    
    assert !@simple_tab.highlighted?(:controller => 'pluto', :action => 'list'),'should NOT highlight'
  
    # add some other highlighting rules
    # and check again
    @simple_tab.highlights=[{:controller => 'pluto'}]
    assert @simple_tab.highlighted?(:controller => 'pluto'), 'should highlight'
  
    @simple_tab.highlights << {:controller => 'granny', :action => 'oyster'}
    assert @simple_tab.highlighted?(:controller => 'granny', :action => 'oyster'), 'should highlight' 
    assert !@simple_tab.highlighted?(:controller => 'granny', :action => 'daddy'), 'should NOT highlight'   
  end
  
  def test_highlighted_dynamic 
    #check that highlights on its own link
    assert @dyntab.highlighted?(:controller => 'pippo', :action => 'Paolo'), 'should highlight'
    assert @dyntab.highlighted?(:controller => 'pippo', :action => 'Paolo', :id => "13"),'should highlight'
    
    assert !@dyntab.highlighted?(:controller => 'pluto'), 'should NOT highlight'
    assert !@dyntab.highlighted?(:controller => 'pippo', :action => 'fake'), 'should NOT highlight'
  
    # add some other highlighting rules
    # and check again
    @dyntab.highlights << {:controller => 'pluto'}
    assert @dyntab.highlighted?(:controller => 'pluto'), 'should highlight'
  
    @dyntab.highlights << {:controller => @mysurname }
    assert @dyntab.highlighted?(:controller => 'Dona'), 'should highlight'
    
    assert !@dyntab.highlighted?(:controller => 'random'), 'should NOT highlight'   
  end
    
  def test_highlighted_on_highlights 
    assert @simple_tab.highlighted?(:controller => 'pippo')
    assert @simple_tab.highlighted?(:controller => 'pippo', :action => 'list')    
    assert !@simple_tab.highlighted?(:controller => 'pluto', :action => 'list')
  end
end