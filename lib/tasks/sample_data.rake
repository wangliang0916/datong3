# encoding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "测试用户",
      mobile_phone: "1" * 11,
      password: "6" * 6,
      password_confirmation: "6" * 6)
    admin.toggle!(:admin)

    9.times do |n|
      name = "u#{n}"
      mobile_phone = (21111111111 + n).to_s
      password = "6" * 6
      User.create!(name:name, 
        mobile_phone: mobile_phone,
        password: password,
        password_confirmation: password)
    end

    9.times do |n|
      name = "c#{n}"
      mobile_phone = (31111111111 + n).to_s
      password = "6" * 6
      Customer.create!(name:name, 
        mobile_phone: mobile_phone)
    end

    9.times do |n|
      t = Task.new
      t.customer_name = "c#{n}"
      t.customer_mobile_phone = "31111111#{111+n}"
      t.content = "content #{n}"
      t.notify_date = "2016-12-22"
      t.notify_time = "08:#{n}"
      t.user = admin
      t.save
    end
    
    admin.customers = Customer.where("id < 5")
    u0 = User.find_by_name("u0")
    u0.customers = Customer.where("id >=5")
  end
end
