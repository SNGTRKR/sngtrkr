FactoryGirl.define do
    factory :suggest do
        ignore { false }

        association :user
        association :artist
    end
end