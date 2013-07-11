require 'spec_helper'
describe Scraper2 do

  describe "#import_artist" do

    let(:import_artist) { Scraper2.import_artist user: build(:user), fb_id: 123, fb_access_token: "abc" }

    context "when an invalid artist is scraped" do
      it "returns false" do
        Scraper2.stub(:scrape_artist) {false}
        import_artist.should eq false
      end
    end

  end

  describe "#scrape_artist" do

    let(:import_artist) { Scraper2.import_artist user: create(:user), fb_id: 123, fb_access_token: "abc" }

    before(:each) do
      Scraper2::Facebook.stub(:scrape_artist) {build(:artist, :itunes_id => nil)}
      Scraper2::LastFm.stub(:improve_artist_info)
      Scraper2::LastFm.stub(:artist_image)
      Scraper2::Itunes.stub(:associate_artist_with_store)
    end

    # TODO: Checking for method calls does not test the output. Should rewrite.
    context "when an artist is scraped from FB" do
      
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

    context "when a user imports an artist" do

      it "follows for new user" do
        count = Follow.count
        Scraper2.import_artist user: create(:user), fb_id: 123, fb_access_token: "abc", first_time: true
        expect(Follow.count-count).to eq 1
      end

      it "suggests for returning user" do
        count = Suggest.count
        import_artist
        expect(Suggest.count-count).to eq 1
      end

    end

  end

  describe "#import_releases_for artist" do
    let(:artist) { create(:artist) }

    before(:each) do
      @release_array = []
      5.times { @release_array << build(:release, artist: artist) }
      Scraper2::Itunes.stub(:scrape_releases_for) { @release_array }
      @tmp_file = Tempfile.new("foo")
      Scraper2::LastFm.stub(:release_image) { @tmp_file }
    end

    it "saves all returned Itunes releases" do
      @release_array.each do |r|
        r.should_receive(:save).once
      end

      Scraper2.import_releases_for artist
    end

    it "assigns all releases images" do
      @release_array.each do |r|
        r.should_receive(:image=).with(@tmp_file).once
      end

      Scraper2.import_releases_for artist
    end
  end

  describe "#scrape_all_missing_release_images" do
    context "when 1 release with images, and 1 without are in DB" do
      before do
        Release.destroy_all
      end

      let(:a) { create(:release, :with_random_image) }
      let(:b) { create(:release) }

      before(:each) do
        a
        b
      end

      it "assigns the 1 without image an image" do
        Scraper2.should_receive(:scrape_missing_release_images).once.with(b)
        Scraper2.scrape_all_missing_release_images
      end

      it "saves the 1 without image" do
        Scraper2.stub(:scrape_missing_release_images) { true }
        Release.any_instance.should_receive(:save)
        Scraper2.scrape_all_missing_release_images
      end

      it "does nothing to the 1 with images" do
        Scraper2.should_not_receive(:scrape_missing_release_images).with(a)
        Scraper2.scrape_all_missing_release_images
      end
    end
  end

end