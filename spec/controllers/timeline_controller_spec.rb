require 'spec_helper'
describe TimelineController do
    describe "GET #populate_user_timeline" do
        it "retrieves the relevant artist from the passed parameter" do
            artist = FactoryGirl.create(:artist)
            assigns(:artist).should eq(artist)
        end
    end
end