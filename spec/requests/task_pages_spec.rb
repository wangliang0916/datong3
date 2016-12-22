# encoding: utf-8
require 'spec_helper'

describe "User Pages" do
  before(:all) { clear_db }

  subject { page }
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      31.times { FactoryGirl.create(:task, user: user) }
      visit user_tasks_path(user)
    end

    it { should have_selector('div.pagination') }

    it "should list each task" do
      user.tasks.paginate(page:1).each do |task|
        expect(page).to have_content(task.content)
      end
    end
  end
end
