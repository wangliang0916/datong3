# encoding: utf-8
include ApplicationHelper

def sign_in(user)
  #puts "utilities: #{user.name} : #{user.admin?}"
  visit signin_path
  fill_in "手机号码", with: user.mobile_phone 
  fill_in "密码", with: user.password
  click_button "登录"
  #sign in when not using Capybara
  cookies[:remember_token] = user.remember_token
end


def clear_db
  User.delete_all
  Customer.delete_all
  Notify.delete_all
  Task.delete_all
end

