FactoryGirl.define do

  factory :user do
    first_name "John"
    last_name  "Doe"
    sequence(:email){|n| "user#{n}@factory.com" }
    password "1234554321"
    email_frequency 1
  end

  factory :artist do
    name "RadioTest"
    sequence(:fbid){|n| n}
  end

  factory :release do
    association :artist, factory: :artist
    name "ReleaseTest"
    sequence(:date){|d| Date.today - d.days}
  end

end