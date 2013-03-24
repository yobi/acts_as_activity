FactoryGirl.define do
  sequence :name do |n|
    "Contest ##{n}"
  end

  factory :contest do
    name
  end
end
