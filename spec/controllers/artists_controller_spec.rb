require 'spec_helper'
describe ArtistsController do

    before :all do
        artist = FactoryGirl.create(:artist)
    end

    describe "GET #show" do
        it "assigns the requested artist to @artist" do
            get :show, id: artist
            assigns(:artist).should eq(artist)
        end

        it "renders the #show view" do
            get :show, id: artist
            response.should render_template :show
        end
    end

    describe "GET #edit" do
        it "assigns the requested artist to @artist" do
            get :edit, id: artist
            assigns(:artist).should eq(artist)
        end
        it "renders the #edit view" do
            get :edit, id: artist
            response.should render_template :edit
        end
    end

    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new artist in the database" do
                expect {
                    post :create, artist: FactoryGirl.attributes_for(:artist)
                }.to change(Artist, :count).by(1)
            end
            it "redirects to the new artist" do
                post :create, artist: FactoryGirl.attributes_for(:artist)
                response.should render_template :show
            end
        end
        context "with invalid attributes" do
            it "does not save the new artist in the database"
                expect {
                    post :create, artist: FactoryGirl.attributes_for(:invalid_artist)
                }.to_not change(Artist, :count)
            end
            it "re-renders the new method" do
                post :create, artist: FactoryGirl.attributes_for(:invalid_artist)
                response.should render_template :new
            end
        end
    end

    describe "PUT #update" do
        before :each do
            @artist = FactoryGirl.create(:artist, name: "Henry hoover", itunes_id: 1245)
        end
        context "with valid attributes" do
            it "located the request @artist" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:artist)
                assigns(:artist).should eq(@artist)
            end

            it "changes @artist's attributes" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:artist, name: "Dyson", itunes_id: 1245)
                @artist.reload
                @artist.name.should eq("Dyson")
                @artist.itunes_id.should eq(1245)
            end
            it "redirects to the updated artist" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:artist)
                response.should redirect_to @artist
            end
        end
        context "with invalid attributes" do
            it "located the requested @artist" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:invalid_artist)
                assigns(:artist).should eq(@artist)
            end

            it "does not change @artist's attributes" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:invalid_artist)#
                @artist.reload
                @artist.name.should_not eq("Dyson")
                @artist.itunes_id eq(1245)
            end

            it "re-renders the edit method" do
                put :update, id: @artist, artist: FactoryGirl.attributes_for(:invalid_artist)
                response.should render_template :edit
            end
        end
    end

    describe "DELETE #destroy" do
        it "deletes the artist" do
            expect {
                delete :destroy, id: artist
            }.to change(Artist, :count).by(-1)
        end

        it "redirects to the home page" do
            delete :destroy, id: artist
            response.should redirect_to :controller => 'pages', :action => 'home'
        end
    end

end