require File.dirname(__FILE__) + '/test_helper'

class TabnavHelperTest < Test::Unit::TestCase
  include Widgets
  
  def setup
    @view = ActionView::Base.new
    @view.extend ApplicationHelper
    @view.extend TabnavHelper
  end
    
  def test_presence_of_instance_methods
    %w{tabnav start_tabnav end_tabnav}.each do |instance_method|
      assert @view.respond_to?(instance_method), "#{instance_method} is not defined in #{@controller.inspect}" 
    end     
  end  
  
end