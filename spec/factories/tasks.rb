# encoding: utf-8
FactoryGirl.define do
  factory :task do
    customer_name "c"
    customer_mobile_phone "11111111111"
    sequence(:content) { |n| "content #{n}" }
    notify_date "2016-12-22"
    notify_time "08:00"
    user
  end
end
