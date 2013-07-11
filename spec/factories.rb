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

end