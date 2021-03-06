require 'spec_helper'

describe Notify do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:notify) { FactoryGirl.build(:notify, customer: customer ) }
  subject { notify }
  it { should respond_to(:content) }
  it { should respond_to(:date) }
  it { should respond_to(:time) }
  it { should respond_to(:customer) }

end
