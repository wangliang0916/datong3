# encoding: utf-8
require 'spec_helper'

describe "notify page" do
  before(:all) { clear_db }
  let(:user) { FactoryGirl.create(:user) }

  let(:customer) { FactoryGirl.create(:customer) }
  subject { page }

  before do
    user.customers << customer
    sign_in user
  end

  describe "new" do
    before { visit new_customer_notify_path(customer) }
    it { should have_selector('title', text: full_title("新建通知")) }

    describe "with valid infomation" do
      before do
        fill_in '通知内容', with: "content"
        fill_in '通知日期', with: "9-1"
        fill_in '时间', with: "8:00"
      end

      it "should create a notify" do
        expect {  click_button '提交' }.to change(customer.notifies, :count)
      end
    end
  end
  
  describe "edit" do
    let(:notify) { FactoryGirl.create(:notify, customer: customer) }
    before { visit edit_customer_notify_path(customer, notify) }
    
    it { should have_selector('title', text: full_title("编辑通知")) }
    
    describe "with valid infomation" do
      before do
        fill_in '通知内容', with: "modify content"
        click_button "更新"
      end

      it { should have_selector('title', text: full_title(customer.name)) }
      it { should have_selector('div.alert.alert-success', text: "成功更新通知") }
      specify { notify.reload.content == "modify content" }
    end
  end
end
