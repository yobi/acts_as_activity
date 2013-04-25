module ActsAsActivity
  module InstanceMethods
    def create_activity
      data = activity_data
      data[:activity_type] = self.class.to_s
      data[:activity_id] = self.id
      Activity.new(data)
    end

    def create_activity!
      create_activity.save
    end

    def activity
      Activity.where(activity_type: self.class.to_s, activity_id: self.id).first
    end

    def update_activity!
      if !self.new_record?
        activity.update_attributes(activity_data)
      end
    end

    def deactivate_activity!
      activity.update_attributes!(active: false)
    end

    def activity_data
      { user_id: get_activity_user,
        subject: activity_subject,
        verb: activity_verb,
        preposition: activity_preposition,
        object: activity_object,
        active: activity_active_when.call(self) }
    end

    def activity_subject
      subject = self.class.activity_sentance[:subject]
      if subject.is_a? Hash
        self.field_from_hash(subject)
      elsif subject.is_a? Proc
        subject.call(self)
      else
        subject
      end
    end

    def activity_verb
      verb = self.class.activity_sentance[:verb]
      if verb.is_a? Hash
        self.field_from_hash(verb)
      elsif verb.is_a? Proc
        verb.call(self)
      else
        verb
      end
    end

    def activity_preposition
      preposition = self.class.activity_sentance[:preposition].nil? ? "" : self.class.activity_sentance[:preposition]
      if preposition.is_a? Hash
        self.field_from_hash(preposition)
      elsif preposition.is_a? Proc
        preposition.call(self)
      else
        preposition
      end
    end

    def activity_object
      object = self.class.activity_sentance[:object]
      if object.is_a? Hash
        self.field_from_hash(object)
      elsif object.is_a? Proc
        object.call(self)
      else
        object
      end
    end

    def get_activity_user
      user = self.class.activity_user
      return user.call(self)
    end

    # @TODO move to utility class
    def field_from_hash(options = {})
      if options[:proc].nil?
        if options[:model].nil?
          self.send(options[:field])
        else
          assoc_name = options[:model].name.downcase.to_sym
          self.send(assoc_name).send(options[:field])
        end
      else
        options[:proc].call(self).send(options[:field])
      end
    end
  end
end
