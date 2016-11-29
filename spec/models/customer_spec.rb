# encoding: utf-8
require 'spec_helper'

describe "customer" do
  before { @customer= FactoryGirl.create(:customer) }
  subject { @customer }

  it { should respond_to(:name) }
  it { should respond_to(:pinyin) }
  it { should respond_to(:mobile_phone) }
  it { should respond_to(:users) }
  it { should respond_to(:attachments) }
  it { should be_valid }
  

  describe "when name is not present" do
    before {@customer.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before {@customer.name = "a"*21 }
    it { should_not be_valid }
  end

  describe "when mobile_phone is not present" do
    before {@customer.mobile_phone = " " }
    it { should_not be_valid }
  end

 describe "when mobile_phone format is invalid" do
    it "should be invalid" do
      mobile_phones = %w[111 a1111111111]
      mobile_phones.each do |mp|
        @customer.mobile_phone = mp
        @customer.should_not be_valid 
      end
    end
 end

 describe "when mobile_phone format is valid" do
    it "should be valid" do
      mobile_phones = %w[11111111111 21111111111]
      mobile_phones.each do |mp|
        @customer.mobile_phone = mp
        @customer.should be_valid 
      end
    end
  end

  describe "when mobile_phone is already taken" do
    before do
      @customer_with_same_phone = @customer.dup
      @customer_with_same_phone.save
    end

    it "should not be valid" do
      @customer_with_same_phone.should_not be_valid
    end
  end

  describe "when assign user" do
    let(:user) { FactoryGirl.create(:user) }
    before { @customer.users << user }

    its(:users) { should include(user) }
    
  end

  describe "pinyin" do
    its(:pinyin) { should_not be_blank }
    its(:pinyin) { should == PinYin.abbr(@customer.name) }
  end
end
