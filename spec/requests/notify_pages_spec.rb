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

    describe "with invalid infomation" do
      it "should not create a notify" do
        expect { click_button '提交' }.not_to change(customer.notifies, :count)
      end      

      before {  click_button '提交' }
      it { should have_selector('title', text: full_title("新建通知")) }
      it { should have_selector('span.validation-error') }
      
    end

    describe "different type" do

      before do
        fill_in '通知内容', with: "content"
        fill_in '时间', with: "8:00"
      end

      describe "select once" do
        before do
          fill_in '通知日期', with: "2016-9-1"
          choose '单次'
        end

        it "should create a once notify" do
          expect {  click_button '提交' }.to change(OnceNotify, :count)
        end
      end

      describe "select every year" do
        before do
          choose '每年'
          fill_in '通知日期', with: "9-1"
        end

        it "should create a every year notify" do
          expect {  click_button '提交' }.to change(EveryYearNotify, :count)
        end
      end

      describe "select every month" do
        before do
          choose '每月'
          fill_in '通知日期', with: "1"
        end

        it "should create a every month notify" do
          expect {  click_button '提交' }.to change(EveryMonthNotify, :count)
        end
      end
    end

    describe "with valid infomation" do
      before do
        fill_in '通知内容', with: "content"
        choose '每年'
        fill_in '通知日期', with: "9-1"
        fill_in '时间', with: "8:00"
      end

      it "should create a notify" do
        expect {  click_button '提交' }.to change(customer.notifies, :count)
      end
      
      describe "redirect to index page" do
        before {  click_button '提交' }
        it { should have_selector('title', text: full_title("通知列表")) } 
        it { should have_selector('div.alert-success', text: "成功创建通知") }
      end
    end
  end
  
  describe "edit" do
    let(:notify) { FactoryGirl.create(:once_notify, customer: customer) }
    before { visit edit_customer_notify_path(customer, notify) }
    
    it { should have_selector('title', text: full_title("编辑通知")) }
    
    describe "with valid infomation" do
      before do
        fill_in '通知内容', with: "modify content"
        click_button "提交"
      end

      it { should have_selector('title', text: full_title("通知列表")) }
      it { should have_selector('div.alert.alert-success', text: "成功更新通知") }
      specify { notify.reload.content == "modify content" }
    end
  end
end
