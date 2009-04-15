# Widgets
require 'widgets/core'
require 'widgets/css_template'
require 'widgets/highlightable'
require 'widgets/disableable'

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
ActionController::Base.helper Widgets::TableHelper

##### Code #####
# not enabled by default because it depends on the Syntax gem
# require 'widgets/code_helper'
# ActionController::Base.helper Widgets::CodeHelper

##### ShowHide #####
require 'widgets/showhide_helper'
ActionController::Base.helper Widgets::ShowhideHelper

##### Tooltip #####
require 'widgets/tooltip_helper'
ActionController::Base.helper Widgets::TooltipHelper

##### Progressbar #####
require 'widgets/progressbar_helper'
ActionController::Base.helper Widgets::ProgressbarHelper

##### Spiffy Corners #####
require 'widgets/spiffy_corners/spiffy_corners_helper'
ActionController::Base.helper Widgets::SpiffyCorners::SpiffyCornersHelper

##### UtilsHelper #####
require 'widgets/utils_helper'
ActionController::Base.helper Widgets::UtilsHelper

