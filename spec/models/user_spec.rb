# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  
	before(:each) do
		@attr = {
			:name => "Marting", 
			:email => "marting@google.com",
			:password => "ajfdsaaf()^faH",
			:password_confirmation => "ajfdsaaf()^faH"
		}
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should validate the resence of name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should validate the presence of email" do
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

	describe "password validations" do

		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => ""))
				.should_not be_valid
		end

		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "foobar"))
				.should_not be_valid
		end

		it "should reject short password" do
			short_password = "a" * 5
			User.new(@attr.merge(:password => short_password, :password_confirmation => short_password))
				.should_not be_valid
		end

		it "should reject long password" do
			long_password = "a" * 41
			User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
				.should_not be_valid
		end
	end

	describe "password encryption" do

		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password" do
			@user.should respond_to(:encrypted_password)
		end

		it "should not be blank" do
			@user.encrypted_password.should_not be_blank
		end

		describe "has_password? method" do
			it "should be true if the password matches" do
				@user.has_password?(@attr[:password])
					.should be_true
			end

			it "should be false if the password doesn't match" do
				@user.has_password?("something")
					.should be_false
			end
		end

		describe "authenticate method" do
			it "should return nil when name password mismatched" do
				wrong_password_user = User.authenticate(
					@attr[:email], "xxx"
					)
				wrong_password_user.should be_nil
			end

			it "should return nil when user doesn't exist" do
				nonexist_user = User.authenticate(
					"stranger", @attr[:password]
					)
				nonexist_user.should be_nil
			end

			it "should return user when matched" do
				ok_user = User.authenticate(
					@attr[:email], @attr[:password]
					)
				ok_user.should == @user
			end

		end
	end
end