# encoding: utf-8
FactoryGirl.define do
    factory :user do
        name "测试用户"
        mobile_phone "1" * 11
        password "foobar"
        password_confirmation "foobar"
    end
end
