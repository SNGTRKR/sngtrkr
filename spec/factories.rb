FactoryGirl.define do
  require 'net/http'

  factory :artist do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    sequence(:fbid) { |n| n }
    sequence(:itunes_id) { |n| n }
    sequence(:sdid) { |n| n }

    trait :with_random_image do
      image { File.open(File.join(Rails.root, '/spec/sample_data/release_100.jpeg')) }
    end

    factory :artist_with_follower do
      after(:create) do |artist|
        artist.followed_users = [FactoryGirl.create(:user)]
      end
    end

  end

  factory :release do
    association :artist, factory: :artist
    sequence(:name) { |n| "#{Faker::Lorem.words(2).map{|w| w.capitalize! }.join(' ')} #{n}" }
    sequence(:date) { |d| Date.today - d.days }

    trait :with_random_image do
      image { File.open(File.join(Rails.root, '/spec/sample_data/release_100.jpeg')) }
    end
  end

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
    user_id FactoryGirl.create(:user).id
    comments "This is the additional comments for the report!"
    url "http://dev.sngtrkr.com:3000/artists/203/releases/173950"
    elements report_hash
    release "Evolution Theory"
  end

end