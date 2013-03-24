module ActsAsActivity
  class Railtie < Rails::Railtie
    initializer 'acts_as_activity.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActsAsActivity::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send(:include, ActsAsActivity::Glue)
      end
    end
  end
end
