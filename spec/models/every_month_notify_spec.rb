require 'spec_helper'

describe EveryMonthNotify do
  before(:all) { clear_db }

  let(:customer) { FactoryGirl.create(:customer) }
  let(:notify) { FactoryGirl.build(:every_month_notify, customer: customer) }

  subject { notify }

  describe "when date format is every month" do
    before { notify.date = "1" }
    it { should be_valid }
  end

  describe "when date format is every year" do
    before { notify.date = "9-1" }
    it { should_not be_valid }
  end

  describe "when date format is once" do
    before { notify.date = "2016-9-1" }
    it { should_not be_valid }
  end

  describe "format date and time" do
    before do
      notify.date = "1"
      notify.time = "8:0"
      notify.save
    end
    specify { notify.reload.date == "01" }
    specify { notify.reload.time == "08:00" }
  end
end
