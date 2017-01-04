# encoding: utf-8
require 'spec_helper'

shared_examples "redirect to sign in" do |command|
  #用http动作可测试response
   #用visit无法测试response
  before { eval(command) }
  specify { response.should redirect_to(signin_path) }
end

describe "Authentication" do
  before(:all) { clear_db }
  subject  { page }

  describe "sign in" do
    before { visit signin_path }

    it { should have_selector('title', text: full_title("登录")) }
    it { should have_link("登录", href: signin_path) }
    
    describe "with invalid information" do
      before { click_button "登录" }

      it { should have_selector('title', text: full_title("登录")) }
      it { should have_selector('div.alert.alert-error', text: "手机号码或密码错误") }

      describe "followed by sign up" do
        before { click_link "注册" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let!(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      it { should have_selector('title', text: full_title("任务列表")) }
      it { should have_link("注销", href: signout_path) }
      
      describe "followed by signout" do
        before { click_link "注销" }
        it { should have_link("登录") }
      end
    end
  end

  describe "none-sign-in user can't visit user" do
    include_examples "redirect to sign in", "get '/users'"
    include_examples "redirect to sign in", "get '/users/search'"
    include_examples "redirect to sign in", "get '/users/1'"
    include_examples "redirect to sign in", "put '/users/1'"
    include_examples "redirect to sign in", "delete '/users/1'"
    include_examples "redirect to sign in", "get '/users/1/edit'"
    include_examples "redirect to sign in", "get '/users/get_by_name'"
  end

  describe "none-sign-in user can't visit customer" do
    include_examples "redirect to sign in", "get '/customers'"
    include_examples "redirect to sign in", "get '/customers/list_all'"
    include_examples "redirect to sign in", "post '/customers'"
    include_examples "redirect to sign in", "get '/customers/new'"
    include_examples "redirect to sign in", "get '/customers/search'"
    include_examples "redirect to sign in", "get '/customers/search_all'"
    include_examples "redirect to sign in", "get '/customers/1'"
    include_examples "redirect to sign in", "put '/customers/1'"
    include_examples "redirect to sign in", "delete '/customers/1'"
    include_examples "redirect to sign in", "get '/customers/1/edit'"
  end



  describe "none-sign-in user can't visit task" do
    include_examples "redirect to sign in", "get '/users/1/tasks'"
  end

  describe "none-sign-in user can't visit notify" do
    include_examples "redirect to sign in", "get '/customers/1/notifies'"
    include_examples "redirect to sign in", "get '/customers/1/notifies/new'"
    include_examples "redirect to sign in", "post '/customers/1/notifies'"
    include_examples "redirect to sign in", "put '/customers/1/notifies/1'"
    include_examples "redirect to sign in", "delete '/customers/1/notifies/1'"
    include_examples "redirect to sign in", "get '/customers/1/notifies/1/edit'"
  end

  describe "none-sign-in user can't visit attachment" do
    include_examples "redirect to sign in", "get '/customers/1/attachments'"
    include_examples "redirect to sign in", "get '/customers/1/attachments/new'"
    include_examples "redirect to sign in", "post '/customers/1/attachments'"
    include_examples "redirect to sign in", "put '/customers/1/attachments/1'"
    include_examples "redirect to sign in", "delete '/customers/1/attachments/1'"
    include_examples "redirect to sign in", "get '/customers/1/attachments/1/edit'"
  end

  describe "none-sign-in user can't visit assign" do
    include_examples "redirect to sign in", "get '/assign/edit'"
    include_examples "redirect to sign in", "post '/assign'"
    include_examples "redirect to sign in", "delete '/assign'"
  end

  describe "none-sign-in user can't visit static pages" do
    include_examples "redirect to sign in", "get '/'"
    include_examples "redirect to sign in", "get '/error'"
  end
end
