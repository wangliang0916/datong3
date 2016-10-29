# encoding: utf-8
require 'spec_helper'

describe "Authentication" do
  subject  { page }

  describe "signin" do
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
      before { sign_in user }

      it { should have_selector('title', text: full_title(user.name)) }
      it { should have_link("所有用户", href: users_path) }
      it { should have_link('资料', href: user_path(user)) }
      it { should have_link('设置', href: edit_user_path(user)) }
      it { should have_link('注销', href: signout_path) }
      it { should_not have_link('登录', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "注销" }
        it { should have_link("登录") }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visit edit user page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: full_title('登录')) }
        end

        describe "提交更新" do 
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: full_title("登录")) }
        end
      end

      describe "试图访问保护页面" do
        before do
          visit edit_user_path(user)
          fill_in "手机号码", with: user.mobile_phone
          fill_in "密码", with: user.password
          click_button "登录"
        end

        describe "登录后" do
          it { should have_selector('title', text: full_title("编辑用户")) }
        end
      end
    end

    describe "错误用户" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, mobile_phone: "2" * 11) }
      before { sign_in user }
      
      describe "访问编辑页面" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title("测试用户")) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
