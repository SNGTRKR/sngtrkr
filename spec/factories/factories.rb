FactoryGirl.define do
  require 'net/http'

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}@factory.com" }
    password "1234554321"
    email_frequency 1
    sequence(:fbid) { |n| n }
    confirmed_at { Time.now }
  end

  report_hash = { :release_name => "0", :artist => "1", :release_date => "0", :label => "0", :purchase_links => "0" }

  factory :report do
    user
    comments "This is the additional comments for the report!"
    url "http://dev.sngtrkr.com:3000/artists/203/releases/173950"
    elements report_hash
    release "Evolution Theory"
  end

  factory :suggest do
    sequence(:user_id) { |n| n }
    sequence(:artist_id) { |n| n }
    ignore {false}
  end

end