# encoding: utf-8
require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:pinyin) }
  it { should respond_to(:mobile_phone) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:customers) }
  it { should be_valid }
  
  describe "with admin attribute set to 'true'" do
    before { user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "when name is not present" do
    before {user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before {user.name = "a"*21 }
    it { should_not be_valid }
  end

  describe "when mobile_phone is not present" do
    before {user.mobile_phone = " " }
    it { should_not be_valid }
  end

 describe "when mobile_phone format is invalid" do
    it "should be invalid" do
      mobile_phones = %w[111 a1111111111]
      mobile_phones.each do |mp|
        user.mobile_phone = mp
        user.should_not be_valid 
      end
    end
 end

 describe "when mobile_phone format is valid" do
    it "should be valid" do
      mobile_phones = %w[11111111111 21111111111]
      mobile_phones.each do |mp|
        user.mobile_phone = mp
        user.should be_valid 
      end
    end
  end

  describe "when mobile_phone is already taken" do
    before do
      @user_with_same_phone = user.dup
      @user_with_same_phone.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
      before { user.password = user.password_confirmation = " " }
      it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
      before { user.password_confirmation = "mismatch" }
      it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
      before { user.password_confirmation = nil }
      it { should_not be_valid }
  end

  describe "return value of authenticate method" do
      before { user.save }
      let(:found_user) { User.find_by_mobile_phone(user.mobile_phone) }

      describe "with valid password" do
          it { should == found_user.authenticate(user.password) }
      end

      describe "with invalid password" do
          let(:user_for_invalid_password) { found_user.authenticate("invalid")}
          it { should_not == user_for_invalid_password }
          specify { user_for_invalid_password.should be_false }
      end

      describe "with a password that's too short" do
          before { user.password = user.password_confirmation = "a" * 5 }
          it { should be_invalid }
      end
  end

  describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "pinyin" do
    before { user.save }
    its(:pinyin) { should_not be_blank }
    its(:pinyin) { should == PinYin.abbr(user.name) }
  end
end

