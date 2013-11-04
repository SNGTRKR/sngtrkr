require 'spec_helper'
describe UsersController do

    login_user

    describe "GET #self" do
        it "redirects to the #show action" do
            response.should redirect_to "/users/#{current_user.id}"
        end
    end
end