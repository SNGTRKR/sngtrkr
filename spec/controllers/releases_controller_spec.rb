require 'spec_helper'
describe ReleasesController do

	before :all do
		release = FactoryGirl.create(:release)
	end

	describe "GET #show" do
        it "assigns the requested release to @release" do
            get :show, id: release
            assigns(:release).should eq(release)
        end

        it "renders the #show view" do
            get :show, id: release
            controller.params[:artist_id].should_not be_nil
            response.should render_template :show
        end
    end

    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new release in the database" do
                expect {
                    post :create, release: FactoryGirl.attributes_for(:release)
                }.to change(Release, :count).by(1)
            end
            it "redirects to the new release" do
                post :create, release: FactoryGirl.attributes_for(:release)
                response.should render_template :show
            end
        end
        context "with invalid attributes" do
            it "does not save the new release in the database"
                expect {
                    post :create, release: FactoryGirl.attributes_for(:invalid_release)
                }.to_not change(Release, :count)
            end
            it "re-renders the new method" do
                post :create, release: FactoryGirl.attributes_for(:invalid_release)
                response.should render_template :new
            end
        end
    end

    describe "DELETE #destroy" do
        it "deletes the release" do
            expect {
                delete :destroy, id: release
            }.to change(Release, :count).by(-1)
        end

        it "redirects to the home page" do
            delete :destroy, id: release
            response.should redirect_to :controller => 'pages', :action => 'home'
        end
    end
end