FactoryGirl.define do

  factory :user do
    first_name "John"
    last_name  "Doe"
    sequence(:email){|n| "user#{n}@factory.com" }
    password "1234554321"
    email_frequency 1
    sequence(:fbid){|n| n}
  end

  factory :artist do
    name "RadioTest"
    sequence(:fbid){|n| n}
    sequence(:itunes_id){|n| n}
    sequence(:sdid){|n| n}

    factory :artist_with_follower do
      after(:create) do |artist|
        artist.followed_users = [FactoryGirl.create(:user)]
      end
    end
  end

  factory :release do
    association :artist, factory: :artist
    name "ReleaseTest"
    sequence(:date){|d| Date.today - d.days}
  end

end