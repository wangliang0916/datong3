require 'spec_helper'

describe EveryYearNotify do
  before(:all) { clear_db }

  let(:customer) { FactoryGirl.create(:customer) }
  let(:notify) { FactoryGirl.build(:every_year_notify, customer: customer) }

  subject { notify }

  describe "when date format is every month" do
    before { notify.date = "1" }
    it { should_not be_valid }
  end

  describe "when date format is every year" do
    before { notify.date = "9-1" }
    it { should be_valid }
  end

  describe "when date format is once" do
    before { notify.date = "2016-9-1" }
    it { should_not be_valid }
  end
end
