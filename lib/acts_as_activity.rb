require 'acts_as_activity/glue'
require 'acts_as_activity/instance_methods'

module ActsAsActivity
  module ClassMethods
    def acts_as_activity(options = {})
      include InstanceMethods
      class_eval do
        def self.activity?
          true
        end
      end
    end

    def activity?
      false
    end
  end
end
