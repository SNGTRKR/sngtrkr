require 'spec_helper'
describe ReportsController do
	describe "GET #new" do
		it "assigns a new Report to @report"
			get :new
			
		end
		it "renders the :new template"
	end

	describe "POST #create" do
		context "with valid attributes" do
			it "saves the new report in the database"
			it "redirects to the artist page"
		end
		context "with invalid attributes" do
			it "does not save the new report in the database"
			it "re-renders the artist page"
		end
	end

	describe "DELETE #destroy" do
		it "removes the report from the database"
		it "redirects to the administration page"
	end
end