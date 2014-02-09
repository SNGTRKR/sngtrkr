FactoryGirl.define do
    factory :release do
        sequence(:name) { |n| "#{Faker::Lorem.words(2).map{|w| w.capitalize! }.join(' ')} #{n}" }
        genre { Faker::Lorem.word }
        sequence(:date) { |d| Date.today - d.days }
        cat_no { Faker::Lorem.characters(5) }
        itunes { Faker::Internet.url } 
        sdigital { Faker::Internet.url } 
        amazon { Faker::Internet.url } 
        juno { Faker::Internet.url } 
        youtube { Faker::Internet.url } 
        label_name { Faker::Lorem.word }
        scraped { true }
        ignore { false }
        twitter { Faker::Internet.url } 
        sequence(:itunes_id) { |n| n }

        factory :with_image do
          image { File.open(File.join(Rails.root, '/spec/sample_data/release_100.jpeg')) }
        end

        association :artist
    end
end