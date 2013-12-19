require 'spec_helper'
describe FollowsController do

	# login_user

	let(:artist) { create(:artist_with_follower) }
	

	describe "GET #index" do
		it "redirects to an artist page" do
			response.should eq 200
			response.body.should include artist_path(artist)
		end
	end

	describe "POST #create" do
		it "increases the users followed artist count by 1" do
			artist.followed_users = [create(:user), create(:user)]
			expect { artist.save }.to change { artist.followed_users.count}.from(1).to(2)
		end
	end

	describe "DELETE #destroy" do
		
	end
end