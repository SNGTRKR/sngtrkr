require 'spec_helper'
describe UsersController do

    before do
        @user = create(:user)
        sign_in @user
    end

    describe "#timeline" do
        # controller.params[:page].should_not be_nil
        context "assigning recommendations from suggested artists relation" do
            it { should have_many(:suggested_artists).through(:suggests).source(:artists) }
        end
        context "assigning recommendations from popular artists" do
            before do
                18.times { create(:artist) }
            end
        end
    end

    describe "GET #show" do
        let(:friend) { create(:user) }
    	context "showing assigns user profile" do
            it "assigns the current_user to @user" do
            	get :show, id: @user
                assigns(:artist).should eq(@user)
            end
            it "renders the #show view" do
                get :show, id: @user
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
            response.should redirect_to "/users/#{@user.id}"
        end
    end

    describe "DELETE #destroy" do
    	it "deletes the user" do
    		expect {
    			delete :destroy, id: @user
    		}.to change(User, :count).by(-1)
    	end

    	it "redirects to home page" do
    		delete :destroy, id: @user
    		response.should redirect_to :controller => 'pages', :action => 'home'
    	end	
    end
end