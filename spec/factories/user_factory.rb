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

  factory :fb_user, class: User do
    email "anthony@namelessnotion.com"
    screenname "namelessnotion"
    facebook_id 9999999999
    facebook_access_token "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  end
end
