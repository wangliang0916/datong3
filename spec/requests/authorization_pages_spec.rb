# encoding: utf-8
require 'spec_helper'

shared_examples "redirect to error" do |command|
  #用http动作可测试response
  #用visit无法测试response
  describe command do
    before { eval(command) }
    specify { response.should redirect_to(error_path) }
  end
end

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
    let(:non_admin) { FactoryGirl.create(:user) }

    before { sign_in non_admin }

    it { should_not have_link("所有用户", href: users_path) }
    it { should_not have_link("所有客户", href: list_all_customers_path) }

    describe "visit user actions" do
      include_examples "redirect to error", "get '/users'"
      include_examples "redirect to error", "get '/users/search'"
      include_examples "redirect to error", "get '/users/get_by_name'"
      include_examples "redirect to error", "delete '/users/1'"
      include_examples "redirect to error", "put '/users/1/reset_password'"
    end
    
    describe "visit customer actions" do
      include_examples "redirect to error", "get '/customers/list_all'"
      include_examples "redirect to error", "get '/customers/search_all'"
      include_examples "redirect to error", "delete '/customers/1'"
    end

    describe "visit assign actions" do
      include_examples "redirect to error", "get '/assign/edit'"
      include_examples "redirect to error", "post '/assign'"
    end
  end

  context "as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    let(:another) { FactoryGirl.create(:user) }

    it { should have_link("所有用户", href: users_path) }
    it { should have_link("所有客户", href: list_all_customers_path) }

    describe "visit other user" do
      
      describe "can show" do
        before { visit user_path(another) }
        it { should have_selector('title', text: full_title(another.name)) }
      end

      include_examples "redirect to error", "get edit_user_path(another)"
      include_examples "redirect to error", "put user_path(another)"

    end

    describe "visit other user's task" do
      before { visit user_tasks_path(another) }
      it { should have_selector('title', text: full_title("任务列表")) }
    end

    describe "visit other user's customer" do
      let(:customer) { FactoryGirl.create(:customer) }
      before { another.customers << customer }
      
      describe "can show" do
        before { visit customer_path(customer) }
        it { should have_selector('title', text: full_title(customer.name)) }
      end

      include_examples "redirect to error", "get edit_customer_path(customer)"
      include_examples "redirect to error", "put customer_path(customer)"

      describe "attachment" do
        describe "can visit index" do
          before { visit customer_attachments_path(customer) }
          it { should have_selector('title', text: full_title("附件列表")) }
        end

        include_examples "redirect to error", "get new_customer_attachment_path(customer)"
        include_examples "redirect to error", "get edit_customer_attachment_path(customer,1)"
        include_examples "redirect to error", "post customer_attachments_path(customer)"
        include_examples "redirect to error", "put customer_attachment_path(customer, 1)"
        include_examples "redirect to error", "delete customer_attachment_path(customer, 1)"

      end

      describe "notify" do
        describe "can visit index" do
          before { visit customer_notifies_path(customer) }
          it { should have_selector('title', text: full_title("通知列表")) }
        end

        include_examples "redirect to error", "get new_customer_notify_path(customer)"
        include_examples "redirect to error", "get edit_customer_notify_path(customer,1)"
        include_examples "redirect to error", "post customer_notifies_path(customer)"
        include_examples "redirect to error", "put customer_notify_path(customer, 1)"
        include_examples "redirect to error", "delete customer_notify_path(customer, 1)"

      end
    end
  end

  context "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, mobile_phone: "2" * 11) }
    before { sign_in user }

    describe "visit other user" do
      include_examples "redirect to error", "get user_path(wrong_user)"
      include_examples "redirect to error", "get edit_user_path(wrong_user)"
      include_examples "redirect to error", "put user_path(wrong_user)"
    end

    describe "visit other user's task" do
      include_examples "redirect to error", "get user_tasks_path(wrong_user)"
    end

    describe "visit other user's customer" do
      let(:customer) { FactoryGirl.create(:customer) }
      before { wrong_user.customers << customer }
      
      include_examples "redirect to error", "get customer_path(customer)"
      include_examples "redirect to error", "get edit_customer_path(customer)"
      include_examples "redirect to error", "put customer_path(customer)"

      describe "attachment" do
        include_examples "redirect to error", "get customer_attachments_path(customer)"
        include_examples "redirect to error", "get new_customer_attachment_path(customer)"
        include_examples "redirect to error", "get edit_customer_attachment_path(customer,1)"
        include_examples "redirect to error", "post customer_attachments_path(customer)"
        include_examples "redirect to error", "put customer_attachment_path(customer, 1)"
        include_examples "redirect to error", "delete customer_attachment_path(customer, 1)"
      end

      describe "notify" do
        include_examples "redirect to error", "get customer_notifies_path(customer)"
        include_examples "redirect to error", "get new_customer_notify_path(customer)"
        include_examples "redirect to error", "get edit_customer_notify_path(customer,1)"
        include_examples "redirect to error", "post customer_notifies_path(customer)"
        include_examples "redirect to error", "put customer_notify_path(customer, 1)"
        include_examples "redirect to error", "delete customer_notify_path(customer, 1)"

      end
    end
  end

end
