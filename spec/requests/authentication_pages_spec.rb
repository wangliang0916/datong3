# encoding: utf-8
require 'spec_helper'

describe "Authentication" do
  subject  { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('title', text: full_title("登录")) }
    it { should have_selector('h1', text: "登录" ) }
    
    describe "with invalid information" do
      before { click_button "登录" }

      it { should have_selector('title', text: full_title("登录")) }
      it { should have_selector('div.alert.alert-error', text: "错误") }

      describe "after visiting another page" do
        before { click_link "注册" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "手机号码", with: user.mobile_phone
        fill_in "密码", with: user.password
        click_button "登录"
      end

      it { should have_selector('title', text: full_title(user.name)) }
      it { should have_link('注销', href: signout_path) }
      it { should_not have_link('登录', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "注销" }
        it { should have_link("登录") }
      end
    end
  end
end
