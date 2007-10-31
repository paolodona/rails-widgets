module Widgets
  module Disableable
    def self.included(base)
      # base.extend(ClassMethods)
      base.class_eval do
        include InstanceMethods
        attr_writer :disabled_condition
      end
    end

    module InstanceMethods 
      def disabled_condition
        @disabled_condition ||= proc { false }
        @disabled_condition
      end
      
      # a disable rule should always be a Proc object
      def disabled_if rule
        self.disabled_condition = rule if rule.kind_of?(Proc)
      end
   
      # Proc evaluates to true/false
      def disabled?
        self.disabled_condition.call
      end
    end
  end
end
