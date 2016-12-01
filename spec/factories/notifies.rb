# encoding: utf-8
FactoryGirl.define do
  factory :notify do
    sequence(:content) { |n| "content #{n}" }
    date "9-1"
    time "8:00"
    customer
  end
end
