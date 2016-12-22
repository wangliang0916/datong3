# encoding: utf-8
require 'spec_helper'

shared_examples "redirect to sign in" do |command|
  #用http动作可测试response
   #用visit无法测试response
  before { eval(command) }
  specify { response.should redirect_to(signin_path) }
end

shared_examples "none-sign-in user visit controller" do |name, actions|
  let(name) { FactoryGirl.create(name) }

  describe "none-sign-in user visit controller #{name}" do
  
    if actions.include?("index")
      describe "index" do  
        include_examples "redirect to sign in", "get #{name}s_path"
      end
    end

    if actions.include?("new")
      describe "new" do
        include_examples "redirect to sign in", "get new_#{name}_path"
      end
    end

    if actions.include?("create")
      describe "create" do
        include_examples "redirect to sign in", "post #{name}s_path"
      end
    end

    if actions.include?("show")
      describe "show" do
        include_examples "redirect to sign in", "get #{name}_path(#{name})"
      end
    end

    if actions.include?("edit")
      describe "edit" do
        include_examples "redirect to sign in", "get edit_#{name}_path(#{name})"
      end
    end

    if actions.include?("update")
      describe "update" do 
        include_examples "redirect to sign in", "put #{name}_path(#{name})"
      end
    end

    if actions.include?("delete")
      describe "delete" do
        include_examples "redirect to sign in", "delete #{name}_path(#{name})"
      end
    end

  end
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

  include_examples "none-sign-in user visit controller", "user", ["index", "show", "edit", "update", "delete"]

  include_examples "none-sign-in user visit controller", "customer", ["index","new", "create", "show", "edit", "update", "delete"]

  include_examples "redirect to sign in", "get user_tasks_path(1)"
end
