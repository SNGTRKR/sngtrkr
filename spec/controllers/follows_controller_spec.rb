require 'spec_helper'
describe FollowsController do

	login_user

	before :all do
		artist = FactoryGirl.create(:artist_with_follower)
	end

	describe "GET #index" do
		it "redirects to an artist page" do
			response.should redirect_to artist_path(artist)
		end
	end

	describe "POST #create" do

	end

	describe "DELETE #destroy" do
		
	end
end