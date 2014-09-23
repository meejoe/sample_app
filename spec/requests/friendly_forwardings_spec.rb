require 'spec_helper'

describe "FriendlyForwardings" do
  describe "GET /friendly_forwardings" do
    it "should forward to the requested page after signed in" do
      user = Factory(:user)
      visit edit_user_path(user)
      # The test automatically follows the redirect to the sign in page
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
      # Test test follows the request again, this time the 'users/edit' page
      response.should render_template('users/edit')
    end
  end
end
