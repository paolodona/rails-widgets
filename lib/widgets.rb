# Widgets
require 'widgets/css_template'
require 'widgets/highlightable'

##### Navigation #####
require 'widgets/navigation_item'
require 'widgets/navigation'
require 'widgets/navigation_helper'
ActionController::Base.helper Widgets::NavigationHelper

##### Tabnav #####
require 'widgets/tab'
require 'widgets/tabnav'
require 'widgets/tabnav_helper'
ActionController::Base.helper Widgets::TabnavHelper

##### Table #####
require 'widgets/table_helper'
ActionView::Base.send :include, Widgets::TableHelper

##### Code #####
require 'widgets/code_helper'
ActionController::Base.helper Widgets::CodeHelper

##### ShowHide #####
require 'widgets'
ActionController::Base.helper Widgets::ShowhideHelper
