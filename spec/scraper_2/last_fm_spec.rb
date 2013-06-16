require 'spec_helper'
describe Scraper2::LastFm do
  let(:good_api_response) do
    # Not technically accurate Radiohead info... If you were wanting that.
  {
    "name"=>"Radiohead", 
    "mbid"=>"a74b1b7f-71a5-4011-9441-d0b5e4122711", 
    "url"=>"http://www.last.fm/music/Radiohead", 
    "image"=>["http://userserve-ak.last.fm/serve/34/3371617.jpg", 
      "http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg"], 
    "bio"=>{"links"=>{"link"=>{"rel"=>"original", 
      "href"=>"http://www.last.fm/music/Radiohead/+wiki"}}, 
      "published"=>"Fri, 30 Jan 2009 20:18:28 +0000", 
      "summary"=>"BIO SUMMARY", 
      "content"=>"FULL CONTENT", 
      "formationlist"=>{"formation"=>{"yearfrom"=>"1986", 
      "yearto"=>nil}}
    }
  }
  end

  let(:bad_api_response) do
    {
      "name"=>"UKF Drum & Bass", 
      "url"=>"http://www.last.fm/music/UKF+Drum+&+Bass", 
      "bio"=>{"links"=>{"link"=>{"rel"=>"original", 
      "href"=>"http://www.last.fm/music/UKF+Drum+&+Bass/+wiki"}}, 
      "summary"=>"\nThis is not an artist", 
      "content"=>"\nThis is not an artist"}
    }
  end

  describe "#improve_artist_info" do


    let(:artist) {Scraper2::LastFm.improve_artist_info Artist.new()}

    context "when an Artist is given" do
      context "and they are real" do
        before(:each) {Scraper2::LastFm.stub(:get_artist_info) {good_api_response} }
        it "improves the name" do
          artist.name.should eq "Radiohead"
        end
        it "improves the bio" do
          artist.bio.should eq "BIO SUMMARY"
        end
      end

      context "and they are non-existent" do
        before(:each) {Scraper2::LastFm.stub(:get_artist_info) {bad_api_response} }
        it "should raise" do
          expect { artist }.to raise_error(ArtistScrapeError)
        end
      end

    end
  end

  describe "#artist_image" do
    let(:artist_image) {Scraper2::LastFm.artist_image Artist.new()}
    context "when a good Artist is given" do
      it "finds an image" do
        Scraper2::LastFm.stub(:get_artist_info) {good_api_response}
        artist_image.should eq "http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg"
      end
    end

    context "when a bad Artist is given" do
      it "returns nil" do
        Scraper2::LastFm.stub(:get_artist_info) {bad_api_response}
        expect(artist_image).to eq nil
      end
    end

  end

  describe "#release_image" do
    let(:good_api_response) do
      {
        "name"=>"The Wall",
        "artist"=>"Pink Floyd",
        "id"=>"2024736",
        "mbid"=>"5f369d91-edcd-4381-acea-95f6c323d40a",
        "url"=>"http://www.last.fm/music/Pink+Floyd/The+Wall",
        "releasedate"=>"    30 Apr 2001, 00:00",
        "image"=>
        ["http://userserve-ak.last.fm/serve/34s/70211546.png",
         "http://userserve-ak.last.fm/serve/300x300/70211546.png",
         "http://userserve-ak.last.fm/best_image.png"],
        "tracks"=>
        {"track"=> []},
      }
    end

    let(:bad_api_response) do
      {
        "name"=>"The Wall",
        "artist"=>"Pink Floyd",
        "id"=>"2024736",
        "mbid"=>"5f369d91-edcd-4381-acea-95f6c323d40a",
        "url"=>"http://www.last.fm/music/Pink+Floyd/The+Wall",
        "releasedate"=>"    30 Apr 2001, 00:00",
        "tracks"=>
        {"track"=> []},
      }
    end

    context "when a good response is returned" do
      it "finds an image" do
        Scraper2::LastFm.stub(:get_album_info) {good_api_response}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq "http://userserve-ak.last.fm/best_image.png"
      end
    end

    context "when a bad response is returned" do
      it "finds an image" do
        Scraper2::LastFm.stub(:get_album_info) {bad_api_response}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq nil
      end
    end
  end

end
