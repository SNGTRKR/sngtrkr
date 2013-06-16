require 'spec_helper'
describe Scraper2 do

  describe "#import_artist" do

    let(:import_artist) { Scraper2.import_artist :user => build(:user), :fb_id => 123, :fb_access_token => "abc" }

    # TODO: Checking for method calls does not test the output. Should rewrite.
    context "when an artist is scraped from FB" do
      before(:each) do
        Scraper2::Facebook.stub(:scrape_artist) {build(:artist, :itunes_id => nil)}
        Scraper2::LastFm.stub(:improve_artist_info)
        Scraper2::LastFm.stub(:artist_image)
        Scraper2::Itunes.stub(:associate_artist_with_store)
      end
      
      it "calls the Facebook scraper once" do
        Scraper2::Facebook.should_receive(:scrape_artist).once
        import_artist
      end
      
      it "calls the LastFm scraper + image scraper once each" do
        Scraper2::LastFm.should_receive(:artist_image).once
        Scraper2::LastFm.should_receive(:improve_artist_info).once
        import_artist
      end

      it "calls the Itunes scraper once" do
        Scraper2::Itunes.should_receive(:associate_artist_with_store).once
        import_artist
      end
    end

    context "when an invalid artist is scraped" do
      it "returns false" do
        Scraper2::Facebook.stub(:scrape_artist) {false}
        import_artist.should eq false
      end
    end

  end

  describe "#import_releases_for artist" do
    let(:artist) { create(:artist) }

    before(:each) do
      @release_array = []
      5.times { @release_array << build(:release, artist: artist) }
      Scraper2::Itunes.stub(:scrape_releases_for) { @release_array }
    end

    it "saves all returned Itunes releases" do
      @release_array.each do |r|
        r.should_receive(:save).once
      end

      Scraper2.import_releases_for artist
    end

    it "assigns all releases images" do
      tmp_file = Tempfile.new("foo")
      Scraper2::LastFm.stub(:release_image) { tmp_file }
      @release_array.each do |r|
        r.should_receive(:image=).with(tmp_file).once
      end

      Scraper2.import_releases_for artist
    end
  end

end