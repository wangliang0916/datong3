# encoding: utf-8
require 'spec_helper'

describe "UserPages" do
  before(:all) { clear_db }

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: full_title("所有用户")) }
    it { should have_selector('h1',  text: "所有用户") }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) }}
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page:1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('删除') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('删除', href: user_path(User.first)) }
        it "should be able to delete antoher user" do
          expect { click_link('删除') }.to change(User, :count).by(-1) 
        end
        it { should_not have_link('删除', href: user_path(admin)) }
      end
    end
  end

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

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('title', text: full_title("测试用户")) }
        it { should have_selector('div.alert.alert-success', text: "欢迎") }  
        it { should have_link("注销") }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('title', text: full_title("编辑用户")) }
      it { should have_selector('h1', text: "更新用户信息") }
    end

    describe "with invalid information" do
      before { click_button "更新" }
      it { should have_xpath('//span[contains(@class,"validation-error")]') }
    end
    
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_phone) { "2" * 11 }
      before do
        fill_in "姓名",  with: new_name
        fill_in "手机号码", with: new_phone
        fill_in "密码", with: "6" * 6
        fill_in "密码确认", with: "6" * 6
        click_button "更新"
      end

      it { should have_selector('title', text: full_title(new_name)) }
      it { should have_link("注销", href: signout_path) }
      it { should have_selector('div.alert.alert-success', text: "更新成功!") }  
      specify { user.reload.name == new_name }
      specify { user.reload.mobile_phone.should == new_phone }
    end
  end

end

