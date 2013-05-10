class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :activity_type, type: String
  field :activity_id, type: String
  field :user_id, type: Integer
  field :subject, type: String
  field :verb, type: String
  field :preposition, type: String
  field :object, type: String
  field :active, type: Boolean
  field :ogp_story_id, type: String

  index({activity_type: 1, activity_id: 1, active: 1}, {unique: true})

  validates_presence_of :activity_type
  validates_presence_of :activity_id
  validates_presence_of :subject
  validates_presence_of :verb
  validates_presence_of :object
  validates_inclusion_of :active, in: [true, false]

  after_create :create_ogp_story
  before_destroy :destroy_ogp_story

  def user
    @user ||= User.find(user_id)
  end

  def create_ogp_story
    if action_class.activity_ogp_enabled? && fb_ogp && ogp_story_id.nil?
      response = fb_ogp.post_story(user.facebook_id, action.ogp_action, { action.ogp_action_type => action.ogp_object_url})
      if response["id"]
        set(:ogp_story_id, response["id"])
      end
    end
  end

  def destroy_ogp_story
    if action_class.activity_ogp_enabled? && fb_ogp && !ogp_story_id.nil?
      begin
        fb_ogp.delete_story(ogp_story_id)
        set(:ogp_story_id, nil)
      rescue
        false
      end
    end
  end

  def action_class
    begin
      @action_class ||= Object.const_get(self.activity_type)
    rescue NameError
      return false
    end
  end

  def action
    if action_class
      @action ||= action_class.find(self.activity_id)
    end
  end

  def fb_ogp
    if user.facebook_id && user.facebook_access_token
      @fb_ogp ||= ActsAsActivity::FacebookOpengraph.new( access_token: user.facebook_access_token)
    else
      false
    end
  end
end
