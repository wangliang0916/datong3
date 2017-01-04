# encoding: utf-8
require 'spec_helper'

describe "Assigns page" do
  before(:all) { clear_db }

  subject { page }

  

  describe "edit assign" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:customer) { FactoryGirl.create(:customer) }
    
    before do
      admin.customers << customer
      sign_in admin
      visit assign_edit_path(customer_id: customer.id) 
    end

    it { should have_selector('title', text: full_title("指派")) }

#    describe "with invalid information" do
#      before do
#        fill_in "姓名",  with: "" 
#        click_button "更新" 
#      end
#      it { should have_selector('span.validation-error') }
#    end
    
#    describe "with valid information" do
#      let(:other_user) { FactoryGirl.create(:user) }
#      before do
#        fill_in "user_id",  with: other_user.id
#        fill_in "customer_id", with: customer.id
#      end
      
#      it "should add a user to customer" do
#        expect { click_button "指派" }.to change(customer.users, :count).by(1)
#      end
#    end
  end

end
