# encoding: UTF-8
require 'spec_helper'

describe "StaticPages" do
    it "should have the title '帮助'" do
      visit '/static_pages/help'
      page.should have_selector('title', text: "大童CRM_帮助")
    end
    
    it "should have h1 'help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', text: "帮助")
    end
end
