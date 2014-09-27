require 'spec_helper'

describe Micropost do
  before(:each) do
  	@user = Factory(:user)
  	@attr = { :content => "vlaue of the content" }
  end

  it "should create a new instance given all valid attributes" do
  	@user.microposts.create!(@attr)
  end

  describe "user associations" do

  	before(:each) do
  		@micropost = @user.microposts.create(@attr)
  	end

  	it "should have a user attribute" do
  		@micropost.should respond_to(:user)
  	end

  	it "should have the right associated user" do
  		@micropost.user_id.should == @user.id
  		@micropost.user.should == @user
  	end
  end

  describe "validations" do

  	it "should require a user id" do
  		Micropost.new(@attr).should_not be_valid
  	end

  	it "should require nonblank content" do
  		@user.microposts.build(:content => "   ").should_not be_valid
  	end

  	it "should reject long content" do
  		@user.microposts.build(:content => "a" * 141).should_not be_valid
  	end
  end

  describe "from_users_followed_by" do

    before(:each) do
      @user_followed = Factory(:user, :email => Factory.next(:email))
      @user_unfollowed = Factory(:user, :email => Factory.next(:email))

      @user_post = @user.microposts.create!(:content => "foo")
      @user_followed_post = @user_followed.microposts.create!(:content => "bar")
      @user_unfollowed_post = @user_unfollowed.microposts.create!(:content => "baz")

      @user.follow!(@user_followed)
    end

    it "should have this class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "should include the followed user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
      Micropost.from_users_followed_by(@user).should include(@user_followed_post)
    end

    it "should not include an unfollowed user's micropost" do
      Micropost.from_users_followed_by(@user).should_not include(@user_unfollowed_post)
    end
  end
end
