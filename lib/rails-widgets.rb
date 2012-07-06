# Widgets
# require 'rails-widgets/core' # append tooltip.js to javascript_link_tag
require 'rails-widgets/css_template'
require 'rails-widgets/highlightable'
require 'rails-widgets/disableable'

##### Navigation #####
require 'rails-widgets/navigation_item'
require 'rails-widgets/navigation'
require 'rails-widgets/navigation_helper'
ActionController::Base.helper Widgets::NavigationHelper

##### Tabnav #####
require 'rails-widgets/tab'
require 'rails-widgets/tabnav'
require 'rails-widgets/tabnav_helper'
ActionController::Base.helper Widgets::TabnavHelper

##### Table #####
require 'rails-widgets/table_helper'
ActionController::Base.helper Widgets::TableHelper

##### Code #####
# not enabled by default because it depends on the Syntax gem
# require 'rails-widgets/code_helper'
# ActionController::Base.helper Widgets::CodeHelper

##### ShowHide #####
require 'rails-widgets/showhide_helper'
ActionController::Base.helper Widgets::ShowhideHelper

##### Tooltip #####
require 'rails-widgets/tooltip_helper'
ActionController::Base.helper Widgets::TooltipHelper

##### Progressbar #####
require 'rails-widgets/progressbar_helper'
ActionController::Base.helper Widgets::ProgressbarHelper

##### Spiffy Corners #####
require 'rails-widgets/spiffy_corners/spiffy_corners_helper'
ActionController::Base.helper Widgets::SpiffyCorners::SpiffyCornersHelper

##### UtilsHelper #####
require 'rails-widgets/utils_helper'
ActionController::Base.helper Widgets::UtilsHelper

