require 'spec_helper'
describe Scraper2::LastFm do

  let(:good_api_response) do
    # Not technically accurate Radiohead info... If you were wanting that.
    { "lfm"=>{"status"=>"ok", 
        "artist"=>{"name"=>"Radiohead", 
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
      }
    }
  end

  let(:bad_api_response) do
    {"lfm"=>{"status"=>"ok", 
    "artist"=>{"name"=>"UKF Drum & Bass", 
    "url"=>"http://www.last.fm/music/UKF+Drum+&+Bass", 
    "image"=>["http://userserve-ak.last.fm/serve/34/76805252.jpg", 
      "http://userserve-ak.last.fm/serve/500/76805252/UKF+Drum++Bass+gg.jpg"], 
    "bio"=>{"links"=>{"link"=>{"rel"=>"original", 
    "href"=>"http://www.last.fm/music/UKF+Drum+&+Bass/+wiki"}}, 
    "summary"=>"\nThis is not an artist", 
    "content"=>"\nThis is not an artist"}}}}
  end

  let(:artist) {Scraper2::LastFm.improve_artist_info Artist.new()}

  context "when an Artist is given for improvement" do
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

  context "when a good Artist is given for image scraping" do
    before(:each) {Scraper2::LastFm.stub(:get_artist_info) {good_api_response} }
    let(:artist_image) {Scraper2::LastFm.artist_image Artist.new()}
    it "finds an image" do
      artist_image.should eq "http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg"
    end
  end

end
