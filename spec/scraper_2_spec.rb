require 'spec_helper'
describe Scraper2 do
  before(:each) do
    Scraper2::facebook_scraper = double("facebook_scraper")
    Scraper2::lastfm_scraper = double("lastfm_scraper")
    Scraper2::itunes_scraper = double("itunes_scraper")      
  end

  let(:import_artist) { Scraper2.import_artist :user => build(:user), :fb_id => 123, :fb_access_token => "abc" }

  context "when an artist is scraped from FB" do
    before(:each) do
      Scraper2::facebook_scraper.stub(:scrape_artist) {build(:artist, :itunes_id => nil)}
      Scraper2::lastfm_scraper.stub(:improve_artist_info)
      Scraper2::lastfm_scraper.stub(:artist_image)
      Scraper2::itunes_scraper.stub(:associate_artist_with_store)
    end
    
    it "calls the Facebook scraper once" do
      Scraper2::facebook_scraper.should_receive(:scrape_artist).once
      import_artist
    end
    
    it "calls the LastFm scraper + image scraper once each" do
      Scraper2::lastfm_scraper.should_receive(:artist_image).once
      Scraper2::lastfm_scraper.should_receive(:improve_artist_info).once
      import_artist
    end

    it "calls the Itunes scraper once" do
      Scraper2::itunes_scraper.should_receive(:associate_artist_with_store).once
      import_artist
    end
  end

  context "when an invalid artist is scraped" do
    before(:each) do
      Scraper2::facebook_scraper.stub(:scrape_artist) {false}
    end

    it "returns false" do
      import_artist.should eq false
    end
  end

end