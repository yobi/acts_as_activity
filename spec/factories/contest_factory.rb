FactoryGirl.define do
  sequence :name do |n|
    "YOBIFoo#{n}"
  end

  factory :contest do
    name
    ogp_type "artist"
  end
end
