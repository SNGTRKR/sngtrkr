require 'spec_helper'
describe Scraper2::Facebook do
  before(:all) do
    @good_graph_response = ActiveSupport::JSON.decode(File.open(File.join('spec', 'sample_data', 'fb_artist_page.json')))
    @bad_graph_response = {"error" => { "message" => "Unsupported get request."}}
  end

  let(:artist) {Scraper2::Facebook.scrape_artist page_id: 12345, access_token: "testaccesstoken"}

  context "when a good page is scraped" do

    before(:each) do
      Scraper2::Facebook.stub(:get_page_from_graph) { @good_graph_response }
    end


    it "returns an Artist object" do
      artist.is_a?(Artist).should eq true
    end
    it "records their name" do
      artist.name.should eq "Joker"
    end
    it "records their fbid" do
      artist.fbid.should eq "214987045200179"
    end
    it "records their bio" do
      artist.bio.should eq "He Joker Boi"
    end
    it "records their genre" do
      artist.genre.should eq "Dubstep"
    end
    it "records their booking agent" do
      artist.booking_email.should eq "francesco@echolocationtalent.com"
    end
    it "records their manager" do
      artist.manager_email.should eq "charles.holgate@gmail.com"
    end
    it "records their hometown" do
      artist.hometown.should eq "Bristol"
    end
    it "records their label" do
      artist.label_name.should eq "Lablol"
    end
    it "records their websites" do
      artist.website.should eq "http://www.myspace.com/thejokerproductions"
      artist.twitter.should eq "Joker"
      artist.youtube.should eq "Joker"
      artist.soundcloud.should eq "Joker"
    end

  end

  context "when a bad page is scraped" do
    before(:each) { Scraper2::Facebook.stub(:get_page_from_graph) { @bad_graph_response } }

    it "returns false" do
      artist.should eq false
    end
  end

end
