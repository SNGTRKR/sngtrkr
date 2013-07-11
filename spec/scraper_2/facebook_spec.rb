require 'spec_helper'
describe Scraper2::Facebook do

  describe "#scrape_artist :page_id, :access_token" do

    let(:artist) {Scraper2::Facebook.scrape_artist page_id: 12345, access_token: "testaccesstoken"}

    context "when a good page is scraped" do
      let(:good_graph_response) { ActiveSupport::JSON.decode(File.open(File.join('spec', 'sample_data', 'fb_artist_page.json'))) }

      before(:each) do
        Scraper2::Facebook.stub(:get_page_from_graph) { good_graph_response }
      end

      it { artist.is_a?(Artist).should eq true }

      it { artist.name.should eq "Joker" }

      it { artist.fbid.should eq "214987045200179" }

      it { artist.bio.should eq "He Joker Boi" }

      it { artist.genre.should eq "Dubstep" }

      it { artist.booking_email.should eq "francesco@echolocationtalent.com" }

      it { artist.manager_email.should eq "charles.holgate@gmail.com" }

      it { artist.hometown.should eq "Bristol" }

      it { artist.label_name.should eq "Lablol" }

      it "records their websites" do
        artist.website.should eq "http://www.myspace.com/thejokerproductions"
        artist.twitter.should eq "Joker"
        artist.youtube.should eq "Joker"
        artist.soundcloud.should eq "Joker"
      end

    end

    context "when a bad page is scraped" do
      let(:bad_graph_response) { {"error" => { "message" => "Unsupported get request."}} }

      before(:each) do
        Scraper2::Facebook.stub(:get_page_from_graph) { bad_graph_response }
      end

      it "raises an error" do
        expect{artist}.to raise_error RuntimeError
      end
    end

  end

  describe "#scrape_artist :fb_data" do
    let(:artist) do
      Scraper2::Facebook.scrape_artist fb_data: ActiveSupport::JSON.decode(File.open(File.join('spec', 'sample_data', 'fb_artist_page.json')))
    end

    context "when good data is provided" do

      it { artist.is_a?(Artist).should eq true }

      it { artist.name.should eq "Joker" }

      it { artist.fbid.should eq "214987045200179" }

      it { artist.bio.should eq "He Joker Boi" }

      it { artist.genre.should eq "Dubstep" }

      it { artist.booking_email.should eq "francesco@echolocationtalent.com" }

      it { artist.manager_email.should eq "charles.holgate@gmail.com" }

      it { artist.hometown.should eq "Bristol" }

      it { artist.label_name.should eq "Lablol" }

      it "records their websites" do
        artist.website.should eq "http://www.myspace.com/thejokerproductions"
        artist.twitter.should eq "Joker"
        artist.youtube.should eq "Joker"
        artist.soundcloud.should eq "Joker"
      end

    end

  end

  describe "Graph API" do

    before(:all) do
      @test_users = Koala::Facebook::TestUsers.new(:app_id => FB_APP_ID, :secret => FB_APP_SECRET)
      @user = @test_users.create(true, 'email,user_likes')
      @graph = Koala::Facebook::API.new(@user["access_token"])
    end

    after(:all) do
      @test_users.delete(@user)
    end

    it "fetches artists ok" do
      music = @graph.get_connections(
        "me", 
        "music?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes"
        )
      expect(music).to eq []
    end

    it "fetches a page ok" do
      page = @graph.api("214987045200179/?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
      expect(page["id"]).to eq "214987045200179"
    end

  end

end
