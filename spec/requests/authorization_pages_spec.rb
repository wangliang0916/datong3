# encoding: utf-8
require 'spec_helper'

describe "authorization" do
  before(:all) { clear_db }

  subject { page }

  describe "for signed in users" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    it { should have_link("资料", href: user_path(user)) }
    it { should have_link("设置", href: edit_user_path(user)) }
    it { should have_link("注销", href: signout_path) }
    it { should have_link("客户列表", href: customers_path) }
    it { should have_link("新客户", href: new_customer_path) }

  end

  context "as non-admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }

    before { sign_in non_admin }

    it { should_not have_link("所有用户", href: users_path) }

    describe "visit users index" do
      before { visit users_path }
      it { should have_selector('title', text: full_title("错误")) }
      it { should have_selector('div.alert.alert-error', text: "请联系系统管理员") }
    end
    
    describe "submitting a DELETE request to the Users#destroy action" do
      before { delete user_path(user) }
      specify { response.should redirect_to(error_path) }
    end
  end

  context "as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }

    it { should have_link("所有用户", href: users_path) }
  end

  context "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, mobile_phone: "2" * 11) }
    before { sign_in user }
    
    describe "visit edit page" do
      before { visit edit_user_path(wrong_user) }
      it { should_not have_selector('title', text: full_title(wrong_user.name)) }
    end

    describe "submitting a PUT request to the Users#update action" do
      before { put user_path(wrong_user) }
      specify { response.should redirect_to(root_path) }
    end
  end
end
