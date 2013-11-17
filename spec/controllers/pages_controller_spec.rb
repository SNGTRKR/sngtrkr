require 'spec_helper'

describe "GET #home" do
    context "if signed in" do
        it "redirects the user to the timeline page" do
            @user = create(:user)
            sign_in @user
            response.should redirect_to '/timeline'
        end
    end
end