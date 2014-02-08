FactoryGirl.define do
    factory :artist do
        name { Faker::Lorem.word }
        genre { Faker::Lorem.word }
        bio { Faker::Lorem.paragraph(3) }
        hometown { Faker::Lorem.word }
        booking_email { Faker::Internet.email }
        manager_email { Faker::Internet.email }
        website { Faker::Internet.url }
        soundcloud { Faker::Internet.url }
        youtube { Faker::Internet.url }
        sd { Faker::Internet.url }
        juno { Faker::Internet.url }
        label_name { Faker::Lorem.word }
        sequence(:fbid) { |n| n }
        ignore { false }
        twitter { Faker::Internet.url }
        sequence(:itunes_id) { |n| n }

        factory :with_random_image do
          image { File.open(File.join(Rails.root, '/spec/sample_data/release_100.jpeg')) }
        end

    end
end