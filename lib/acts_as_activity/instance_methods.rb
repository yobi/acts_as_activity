module ActsAsActivity
  module InstanceMethods
    def create_activity
      Activity.create(activity_type: self.class.to_s, activity_id: self.id)
    end
  end
end
