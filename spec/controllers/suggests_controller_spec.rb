require 'spec_helper'
describe SuggestsController do

	login_user
	before :each do 
		@artist = FactoryGirl.create(:artist)
	end	

	controller.params[:artist_id].should_not be_nil
	current_user.followed_artists = [1,2,3,4]

	describe "POST #create" do
		context "with valid attributes" do
            it "should have one more item in it's collection" do
                current_user.followed_artists.should have(5).items
            end
            it "redirects to the artist" do
                response.should redirect_to artist_path(@artist)
            end
        end
        context "with invalid attributes" do
            it "does not add a new item to the collection"
                current_user.followed_artists.should have(4).items
            end
        end
	end

	describe "DELETE #destroy" do
		it "should decrement the number of items by one" do
			current_user.followed_artists.should have[3].items
		end
	end
end