# encoding: utf-8
require 'spec_helper'

describe "Customers page" do
  before(:all) { clear_db }

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "index" do
    before { visit customers_path }

    describe "page" do
      it { should have_selector('title', text: full_title("客户列表")) }
      it { should have_selector('h1',  text: "客户列表") }
    end

    describe "list customer" do
      before(:all) { 31.times { user.customers << FactoryGirl.create(:customer) }}
      after(:all) { Customer.delete_all }
      
      context "current user" do
        it { should_not have_content("所有客户") }
        it { should have_selector('div.pagination') }

        it "should list each customer" do
          Customer.paginate(page:1).each do |customer|
            expect(page).to have_link(customer.name, href: customer_path(customer))
            expect(page).to have_link(customer.mobile_phone, href: customer_path(customer))
            expect(page).to have_link(user.name, href:user_path(user))
            expect(page).to have_link("编辑", href: edit_customer_path(customer))
            expect(page).to have_link("取消指派", href: assign_path(customer), method: 'delete')
            expect(page).not_to have_link("指派", href:edit_assign_path(customer))
            expect(page).not_to have_link("删除", href:customer_path(customer), method: 'delete' )
          end
        end

        it "should unassign a customer" do
          expect { click_link "取消指派" }.to change(user.customers, :count).by(-1)
        end

        it "should not destroy a customer" do
          expect { click_link "取消指派" }.not_to change(Customer, :count)
        end

      end

      context "other user" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          sign_in other_user
          visit customers_path
        end
        it { should_not have_selector('div.pagination') }
      end
    end

    context "admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:customer) { FactoryGirl.create(:customer) }
      before do
        admin.customers << customer 
        sign_in admin
        visit customers_path
      end

      describe "page" do
        it { should have_unchecked_field("所有客户") }
        it { should have_link("删除", href:customer_path(customer), method:'delete') }
        it { should have_link("指派", href:edit_assign_path(customer)) }
      end

      it "should destroy customer" do
        expect { click_link("删除") }.to change(Customer, :count).by(-1)
      end
    end
  end

  describe "new customer" do

    before { visit new_customer_path }

    describe "page" do
      it { should have_selector('title', text: full_title("新客户")) }
      it { should have_selector('h1', text: "新客户") }
    end

    describe "with invlid infomation" do
      it "should not create a customer" do
        expect { click_button "创建客户" }.not_to change(Customer, :count)
      end
    end

    describe "with valid infomation" do
      before do
        fill_in "姓名",  with: "测试客户"
        fill_in "手机号码", with: "1" * 11
      end

      after do
        Customer.delete_all
      end
      
      it "should create a customer" do
        expect { click_button "创建客户" }.to change(Customer, :count).by(1)
      end

      it "should assign to current user" do
        expect { click_button "创建客户" }.to change(user.customers, :count).by(1)
      end

      describe "after saving the customer" do
        before { click_button "创建客户" }

        it { should have_selector('title', text: full_title("测试客户")) }
        it { should have_selector('div.alert.alert-success', text: "创建成功") }  
      end
    end
  end

  describe "edit customer" do
    let(:customer) { FactoryGirl.create(:customer) }

    before { visit edit_customer_path(customer) }

    describe "page" do
      it { should have_selector('title', text: full_title("编辑客户")) }
      it { should have_selector('h1', text: "编辑客户") }
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
      specify { customer.reload.name == new_name }
      specify { customer.reload.mobile_phone.should == new_phone }
    end
  end

end
