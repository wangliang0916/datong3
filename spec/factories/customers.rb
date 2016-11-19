# encoding: utf-8
FactoryGirl.define do
    factory :customer do
        sequence(:name) { |n| "c#{n}" }
        sequence(:mobile_phone) { |n| (11111111111 + n).to_s }
    end
end
