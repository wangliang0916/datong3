# encoding: utf-8
require 'spec_helper'

describe "Assigns page" do
  before(:all) { clear_db }

  subject { page }

  

  describe "edit assign" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:customer) { FactoryGirl.create(:customer) }
    let(:other_user) { FactoryGirl.create(:user) }
    
    before do
      admin.customers << customer
      sign_in admin
      visit edit_assign_path(customer) 
    end

    describe "page" do
      it { should have_selector('title', text: full_title("编辑指派")) }
      it { should have_selector('h1', text: "编辑指派") }
    end

    describe "with invalid information" do
      before do
        fill_in "姓名",  with: "" 
        click_button "更新" 
      end
      it { should have_selector('span.validation-error') }
    end
    
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_phone) { "2" * 11 }
      before do
        fill_in "姓名",  with: new_name
        fill_in "手机号码", with: new_phone
        click_button "更新"
      end

      it { should have_selector('title', text: full_title(new_name)) }
      it { should have_selector('div.alert.alert-success', text: "更新成功") }  
      specify { assign.reload.name == new_name }
      specify { assign.reload.mobile_phone.should == new_phone }
    end
  end

end
