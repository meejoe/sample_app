require 'spec_helper'

describe "LayoutLinks" do

    it "should have a Home page at '/'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/'
      response.status.should be(200)
      response.should have_selector('title', :content => "Home")
    end

    it "should have a Home page at '/contact'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/contact'
      response.status.should be(200)
      response.should have_selector('title', :content => "Contact")
    end

    it "should have a Home page at '/about'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/about'
      response.status.should be(200)
      response.should have_selector('title', :content => "About")
    end

    it "should have a Home page at '/help'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/help'
      response.status.should be(200)
      response.should have_selector('title', :content => "Help")
    end

    it "should have a Home page at '/signup'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/signup'
      response.status.should be(200)
      response.should have_selector('title', :content => "Sign up")
    end

    it "should have the right links on the layout" do
      visit root_path
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      click_link "Home"
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign up")
    end

    describe "when not signed in" do
      it "should have a signin link" do
        visit root_path
        response.should have_selector("a", :content => "Sign in",
                                           :href => signin_path)
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = Factory(:user)
        visit signin_path
        fill_in :email, :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a sign out link" do
        visit root_path
        response.should have_selector("a", :content => "Sign out",
                                           :href => signout_path)
      end

      it "should have a profile link" do
        visit root_path
        response.should have_selector("a", :content => "Profile",
                                           :href => user_path(@user))
      end
    end
end
