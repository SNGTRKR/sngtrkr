FactoryGirl.define do
    factory :follow do

        association :artist
        association :user
    end
end