FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}@factory.com" }
    password "1234554321"
    email_frequency 1
    sequence(:fbid) { |n| n }
    confirmed_at { Time.now }
  end
end
