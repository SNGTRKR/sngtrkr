FactoryGirl.define do

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) { |n| "user#{n}@factory.com" }
    password "1234554321"
    email_frequency 1
    sequence(:fbid) { |n| n }
    confirmed_at Time.now
  end

  factory :artist do
    name "#{Faker::Name.first_name} #{Faker::Name.last_name}"
    sequence(:fbid) { |n| n }
    sequence(:itunes_id) { |n| n }
    sequence(:sdid) { |n| n }

    factory :artist_with_follower do
      after(:create) do |artist|
        artist.followed_users = [FactoryGirl.create(:user)]
      end
    end

    factory :artist_with_releases do
      after(:create) do |artist|
        5.times do
          artist.releases << build(:release, artist: artist)
        end
      end
    end

  end

  factory :release do
    association :artist, factory: :artist
    sequence(:name) { |n| "#{Faker::Lorem.words(2).map{|w| w.capitalize! }.join(' ')} #{n}" }
    sequence(:date) { |d| Date.today - d.days }
  end

end