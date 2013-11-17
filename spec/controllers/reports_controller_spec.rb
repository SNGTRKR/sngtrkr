require 'spec_helper'
describe ReportsController do

	describe "POST #create" do
		before :each do
			@artist = create(:artist)
		end
		context "with valid attributes" do
			it "saves the new report in the database" do
				# expect proc - expect the following code to do or not do something
				expect {
					post :create, report: build(:report)
				}.to change(Report,:count).by(1)
			end
			it "redirects to the artist page" do
				post :create, report: build(:report)
				response.should redirect_to :controller => 'artists', :action => 'show', :id => @artist.id
			end
		end
		context "with invalid attributes" do
			it "does not save the new report in the database" do
				expect {
					post :create, report: build(:invalid_report)
				}.to_not change(Report, :count)
			end
			it "re-renders the artist page" do
				post :create, contact: build(:invalid_report)
				response.should redirect_to :controller => 'artists', :action => 'show', :id => @artist.id
			end
		end
	end

	describe "DELETE #destroy" do
		before :each do
			@report = build(:report)
		end
		it "removes the report from the database" do
			expect {
				delete :destroy, id: @report
			}.to change(Report, :count).by(-1)
		end
		it "redirects to the administration page" do
			delete :destroy, id: @report
			response.should redirect_to :controller => 'admin', :action => 'overview'
		end
	end
end