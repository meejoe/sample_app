require 'spec_helper'

describe "Microposts" do

	before(:each) do
		@user = Factory(:user)
		visit signin_path
		fill_in :email, :with => @user.email
		fill_in :password, :with => @user.password
		click_button
	end

	describe "creation" do

		describe "failure" do

			it "should not make a new micropost" do
				lambda do
					visit root_path
					fill_in :micropost_content, :with => ""
					click_button
					response.should render_template('pages/home')
					response.should have_selector("div#error_explanation")
				end.should_not change(Micropost, :count)
			end
		end

		describe "success" do

			it "should make a new micropost" do
				content = "Lorem ipsum dolor sit amet"
				lambda do
					visit root_path
					fill_in :micropost_content, :with => content
					click_button
					response.should have_selector("span.content", :content => content)
				end.should change(Micropost, :count).by(1)
			end
		end
	end

	describe "sidebar micropost count" do

		it "should display right count of current user microposts with proper pluralization" do
			content = "Lorem ipsum dolor sit amet"
			visit root_path
			fill_in :micropost_content, :with => content
			click_button
			response.should have_selector("span.microposts", :content => "1 micropost")
			visit root_path
			fill_in :micropost_content, :with => content
			click_button
			response.should have_selector("span.microposts", :content => "2 microposts")
		end
	end

	describe "home page status feed" do

		before(:each) do
			#create microposts and refresh home page
			40.times do
				@user.microposts.create!(:content => "Test sentence")
			end
		end

		it "should paginate microposts" do
			click_link "Home"
			response.should have_selector("div.pagination")
			response.should have_selector("span.disabled", :content => "Previous")
			response.should have_selector("a", :href => "/?page=2",
			                                 :content => "2")
			response.should have_selector("a", :href => "/?page=2",
			                                 :content => "Next")
		end

		it "should have links to delete microposts created by the current user"

		it "should not have links to delete microposts not created by current user"
	end
end