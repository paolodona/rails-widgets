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

end