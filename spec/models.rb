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
           type: { model: Contest, field: :ogp_type },
    auto_create: false }
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
           type: { model: Contest, field: :ogp_type }},
    auto_create: true
end
