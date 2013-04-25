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
end
