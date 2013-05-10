require 'mongoid'
require 'rest-more'
require 'acts_as_activity/glue'
require 'acts_as_activity/instance_methods'
require 'acts_as_activity/documents/activity'
require 'acts_as_activity/facebook_opengraph'
require 'acts_as_activity/railtie'

module ActsAsActivity
  module ClassMethods
    def acts_as_activity(options = {})
      include InstanceMethods
      class_eval do
        def self.activity?
          true
        end
      end

      class_attribute :activity_auto_create
      self.activity_auto_create = options[:auto_create]
      class_attribute :create_activity_on
      self.create_activity_on = options[:create_on]
      class_attribute :activity_sentance
      self.activity_sentance = options[:sentance]

      if options[:ogp]
        class_attribute :activity_ogp
        self.activity_ogp = options[:ogp]
        Rails.logger.debug(self.activity_ogp)
        class_eval do
          def self.activity_ogp_enabled?
            true
          end
        end
      end

      class_attribute :activity_active_when
      self.activity_active_when = options[:active_when]
      class_attribute :activity_user
      self.activity_user = options[:action_user]

      if activity_auto_create
        after_create :create_activity!
        after_save :update_activity!
        after_destroy :deactivate_activity!
      end

    end

    def activity?
      false
    end

    def activity_ogp_enabled?
      false
    end
  end
end
