# encoding: utf-8
require 'spec_helper'

describe "UserPages" do
  
    subject { page }

    describe "signup page" do
        before { visit signup_path }
    
        it { should have_selector('title', text: full_title("注册")) }

        it { should have_selector('h1', text: "注册") }
    
    end

    describe "profile page" do
        let(:user) { FactoryGirl.create(:user) } 
        before { visit user_path(user) }

        it { should have_selector('title', text: full_title(user.name)) }
        it { should have_selector('h1', text: user.name) }
    end

    describe "signup" do
      before { visit signup_path }
      let(:submit) { "创建用户" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
      end

      describe "with valid information" do
        before do
          fill_in "姓名",  with: "测试用户"
          fill_in "手机号码", with: "1" * 11
          fill_in "密码", with: "6" * 6
          fill_in "密码确认", with: "6" * 6
        end
        
        it "should create a user" do
          expect { click_button submit }.to change(User, :count)
        end
      end
    end
end
