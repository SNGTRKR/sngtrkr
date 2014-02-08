FactoryGirl.define do
    factory :release do
        sequence(:name) { |n| "#{Faker::Lorem.words(2).map{|w| w.capitalize! }.join(' ')} #{n}" }
        genre { Faker::Lorem.word }
        sequence(:date) { |d| Date.today - d.days }
        cat_no { Faker::Lorem.characters(5) }
        itunes { Faker::Internet.Url } 
        sdigital { Faker::Internet.Url } 
        amazon { Faker::Internet.Url } 
        juno { Faker::Internet.Url } 
        youtube { Faker::Internet.Url } 
        label_name { Faker::Lorem.word }
        scraped true
        ignore false
        twitter { Faker::Internet.Url } 
        sequence(:itunes_id) { |n| n }

        factory :with_random_image do
          image { File.open(File.join(Rails.root, '/spec/sample_data/release_100.jpeg')) }
        end

        association :artist
    end
end