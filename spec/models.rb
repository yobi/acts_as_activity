class User < ActiveRecord::Base
  has_many :contestants
end

class Contest < ActiveRecord::Base
  has_many :contestants
end

class Contestant < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user
  acts_as_activity active_when: Proc.new { |contestant| contestant.published? && contestant.processed? && contestant.active? },
    action_user: Proc.new { |contestant| contestant.user_id },
    sentance: { subject: { model: User, field: :screenname },
                verb: "submitted a contest entry, ",
                object: { field: :title }},
    ogp: { action: :publish,
           type: { model: Contest, field: :ogp_type }},
    auto_create: false
end

class Post
  include Mongoid::Document
  field :body, type: String
  field :user_id, type: Integer
  embeds_many :comments
end

class Comment
  include Mongoid::Document
  include ActsAsActivity::Glue
  field :body, type: String
  field :user_id, type: Integer
  embedded_in :post
  acts_as_activity active_when: Proc.new { |comment| true },
    action_user: Proc.new { |comment| User.find(comment.user_id) },
    sentance: { subject: Proc.new { |comment| User.find(comment.user_id).screenname },
                verb: "commented on",
                object: "a post"},
    auto_create: true
end

class Vote
  include Mongoid::Document
  include ActsAsActivity::Glue
  field :contestant_id, type: Integer
  field :user_id, type: Integer
  field :casted_at, type: DateTime, default: ->{ Time.zone.now }
  field :active, type: Boolean

  acts_as_activity active_when: Proc.new { |vote| Contestant.find(vote.contestant_id).active && vote.active },
    action_user: Proc.new { |vote| vote.user_id },
    sentance: {
      subject: Proc.new { |ballot_vote| User.find(ballot_vote.user_id).screenname },
      verb: "voted for",
      object: { proc: Proc.new { |vote| Contestant.find(vote.contestant_id) }, dependent: true, field: :title }},
    ogp: { action: :vote_for,
           type: Proc.new { |vote| Contestant.find(vote.contestant_id).contest.ogp_type.to_sym },
           object: Proc.new { |vote| vote.object_url }},
    auto_create: true

  def object_url
    contestant = Contestant.find(contestant_id)
    "/#{contestant.contest.name.downcase}/contestant/#{contestant.user.screenname}"
  end
end
