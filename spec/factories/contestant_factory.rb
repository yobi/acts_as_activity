FactoryGirl.define do

  sequence :title do |n|
    "Contest Entry ##{n}"
  end

  factory :contestant do
    title
    contest
    user
    created { Time.now }
    modified { Time.now }
    active 1
    published 1
    processed 1
  end
end
