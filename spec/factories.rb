# encoding: utf-8
FactoryGirl.define do
    factory :user do
        sequence(:name) { |n| "u#{n}" }
        sequence(:mobile_phone) { |n| (11111111111 + n).to_s }
        password "666666"
        password_confirmation "666666"
        factory :admin do
          admin true
        end
    end
end
