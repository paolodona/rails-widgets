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
