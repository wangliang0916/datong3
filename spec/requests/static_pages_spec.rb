# encoding: UTF-8
require 'spec_helper'

describe "StaticPages" do
    subject { page }

    describe "help page" do
      before { visit '/static_pages/help'}
    
      it { should have_selector('title', text: full_title("帮助")) }
    
      it { should have_selector('h1', text: "帮助") }
    end
end
