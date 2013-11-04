require 'spec_helper'
describe UsersController do

    login_user

    describe "#timeline" do
        controller.params[:page].should_not be_nil
        context "assigning recommendations from suggested artists relation" do
            it { should have_many(:suggested_artists).through(:suggests).source(:artists) }
        end
        context "assigning recommendations from popular artists" do
            FactoryGirl.create_list(:artist, 18)
        end
    end

    describe "GET #show" do
        friend = FactoryGirl.create(:user)
    	context "showing a user profile" do
            it "assigns the current_user to @user" do
            	get :show, id: current_user
                assigns(:artist).should eq(current_user)
            end
            it "renders the #show view" do
                get :show, id: current_user
                response.should render_template :show     
            end
        end
        context "showing a friends profile" do
            it "assigns the friend user to @friend" do
                get :show, id: friend
                assigns(:friend).should eq(friend)
            end
            it "renders the #show view" do
                get :show, id: friend
                response.should render_template :show     
            end
        end
    end

    describe "GET #self" do
        it "redirects to the #show action" do
            response.should redirect_to "/users/#{current_user.id}"
        end
    end

    describe "DELETE #destroy" do
    	it "deletes the user" do
    		expect {
    			delete :destroy, id: current_user
    		}.to change(User, :count).by(-1)
    	end

    	it "redirects to home page" do
    		delete :destroy, id: current_user
    		response.should redirect_to :controller => 'pages', :action => 'home'
    	end	
    end
end