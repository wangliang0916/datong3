# encoding: utf-8
FactoryGirl.define do
  factory :notify do
    sequence(:content) { |n| "content #{n}" }
    time "8:00"
    customer
  end

  factory :once_notify, class:'OnceNotify', parent: :notify do
    date "2016-9-1"
    type "OnceNotify"
  end

  factory :every_year_notify, class:'EveryYearNotify', parent: :notify  do
    date "9-1"
    type "EveryYearNotify"
  end
  factory :every_month_notify, class:'EveryMonthNotify', parent: :notify do
    date "1"
    type "EveryMonthNotify"
  end
end
