module Widgets
  module SpiffyCorners
    module SpiffyCornersHelper

      protected

      include CssTemplate
      def spiffy_corners opts={}, &block
        raise "you must pass spiffy_corners a block!" unless block_given?
        html = []
        html << render_css('spiffy_corners/spiffy_corners') if opts[:generate_css] == true
        @_spiffy_corners_content = capture(&block) 
        html << rw_render_template('spiffy_corners/spiffy5', binding)
       
        concat html.join
        return nil
      end
    end
  end
end
