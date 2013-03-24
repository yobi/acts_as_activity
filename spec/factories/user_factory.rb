FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@email.com"
  end

  sequence :screenname do |n|
    "person#{n}"
  end

  factory :user do
    email
    screenname
  end
end
