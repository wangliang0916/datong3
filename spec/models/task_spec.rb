require 'spec_helper'

describe Task do
  before(:all) { clear_db }
  
  describe "check attributs" do
    before { @task = Task.new }
    it "should respond" do
      expect(@task).to respond_to(:user)
      expect(@task).to respond_to(:content)
      expect(@task).to respond_to(:notify_date)
      expect(@task).to respond_to(:notify_time)
      expect(@task).to respond_to(:customer_name)
      expect(@task).to respond_to(:customer_mobile_phone)
    end
  end

  before do
    @user = FactoryGirl.create(:user)
    @customer = FactoryGirl.create(:customer)
    @user.customers << @customer 
  end

  describe "create once_notify task" do
    before do
      @once_notify = FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}") 
    end

    it "should create once_notify task" do
      expect { Task.generate_tasks }.to change(Task, :count)
    end
  end

  describe "create every_year_notify task" do
    before do
      @every_year_notify = FactoryGirl.create(:every_year_notify, customer: @customer, date:"#{Time.now.month}-#{Time.now.day}") 
    end

    it "should create every_year_notify task" do
      expect { Task.generate_tasks }.to change(Task, :count)
    end
  end

  describe "create every_month_notify task" do
    before do
      @every_month_notify = FactoryGirl.create(:every_month_notify, customer: @customer, date:"#{Time.now.day}") 
    end
    it "should create every_month_notify task" do
      expect { Task.generate_tasks }.to change(Task, :count)
    end
  end

  describe "one customer two user" do
    before do
      @u2 = FactoryGirl.create(:user)
      @u2.customers << @customer
      FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}") 
    end
    it "should create two task" do
      expect { Task.generate_tasks }.to change(Task, :count).by(2)
    end
  end

  describe "create correct infomation" do
    before do
      @notify = FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}") 
      Task.delete_all
      Task.generate_tasks
      @task = Task.first
    end

    it "should have same content with notify" do
      expect(@task.user).to eq(@user)
      expect(@task.customer_name).to eq(@customer.name)
      expect(@task.customer_mobile_phone).to eq(@customer.mobile_phone)
      expect(@task.content).to eq(@notify.content)
      expect(@task.notify_date).to eq(@notify.date)
      expect(@task.notify_time).to eq(@notify.time)
    end
  end

  describe "list should sort by date and time" do
    before do
      @n1 = FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}",time: "07:00") 
      @n2 = FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}",time: "08:00") 
      @n3 = FactoryGirl.create(:once_notify, customer: @customer, date:"#{Time.now.year}-#{Time.now.month}-#{Time.now.day}",time: "06:00") 
      Task.delete_all
      Task.generate_tasks
    end

    it "should have task in right order" do
      expect(@user.tasks.collect{|t| t.notify_time }).to eq([@n2.time, @n1.time, @n3.time])
    end
  end
  
end
