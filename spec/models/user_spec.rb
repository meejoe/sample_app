# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  
	before(:each) do
		@attr = {:name => "Marting", :email => "marting@google.com"}
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should validate the resence of name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should validate the resence of email" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end

	it "should reject names that are too long" do
		long_name = "a" * 51
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end

	it "should accept valid emails" do
		valid_emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		valid_emails.each do |valid_email|
			valid_email_user = User.new(@attr.merge(:email => valid_email))
			valid_email_user.should be_valid
		end
	end

	it "should reject invalid emails" do
		invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
		invalid_emails.each do |invalid_email|
			invalid_email_user = User.new(@attr.merge(:email => invalid_email))
			invalid_email_user.should_not be_valid
		end
	end

	it "should have an unique email" do
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid
	end

	it "should reject email identical up to case" do
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.email = user_with_duplicate_email.email.upcase
		user_with_duplicate_email.should_not be_valid
	end
end
