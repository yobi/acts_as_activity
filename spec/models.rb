class User < ActiveRecord::Base
  has_many :contestants
end

class Contestant < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user
  acts_as_activity

end

class Contest < ActiveRecord::Base
  has_many :contestants
end

class BallotVote
  include Mongoid::Document
end
