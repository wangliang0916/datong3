# encoding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "测试用户",
      mobile_phone: "1" * 11,
      password: "6" * 6,
      password_confirmation: "6" * 6)
    admin.toggle!(:admin)

    99.times do |n|
      name = "u#{n}"
      mobile_phone = (21111111111 + n).to_s
      password = "6" * 6
      User.create!(name:name, 
        mobile_phone: mobile_phone,
        password: password,
        password_confirmation: password)
    end

    99.times do |n|
      name = "c#{n}"
      mobile_phone = (21111111111 + n).to_s
      password = "6" * 6
      Customer.create!(name:name, 
        mobile_phone: mobile_phone)
    end
    
    admin.customers = Customer.where("id < 32")
    u0 = User.find_by_name("u0")
    u0.customers = Customer.where("id >=32")
  end
end
