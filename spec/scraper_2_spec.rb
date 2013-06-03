require 'spec_helper'
require 'open-uri'
describe "Scraper2" do

  context "when an artist is scraped" do
    it "returns an Artist object" do
      pending
    end
  end

  context "when an invalid artist is scraped" do
    it "returns false" do
      pending
    end
  end

end

describe "Scraper2::Facebook" do
  before(:all) do
    @good_graph_response = ActiveSupport::JSON.decode(File.open(File.join('spec', 'sample_data', 'fb_artist_page.json')))
    @bad_graph_response = {"error" => { "message" => "Unsupported get request."}}
  end

  context "when a good page is scraped" do

    before(:each) do
      Scraper2::Facebook.stub(:get_page_from_graph) { @good_graph_response }
    end

    let(:artist) {Scraper2::Facebook.scrape_artist 12345, "testaccesstoken"}

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
    let(:artist) {Scraper2::Facebook.scrape_artist 12345, "testaccesstoken"}

    it "returns false" do
      artist.should eq false
    end
  end

end

describe "Scraper2::Itunes" do
  let(:artist) {Scraper2::Itunes.associate_artist_with_store(Artist.new)}

  context "when a good Artist is given for store association" do
      let(:good_itunes_api_response) do 
          [
          {"wrapperType"=>"artist", 
            "artistType"=>"Artist", 
            "artistName"=>"Radiohead", 
            "artistLinkUrl"=>"https://itunes.apple.com/gb/artist/radiohead/id657515?uo=4", 
            "artistId"=>657515, 
            "amgArtistId"=>41092, 
            "primaryGenreName"=>"Alternative", 
            "primaryGenreId"=>20}, 
          {"wrapperType"=>"artist", 
            "artistType"=>"Artist", 
            "artistName"=>"Only The Hits Artists - Radiohead Tribute Ringtone", 
            "artistLinkUrl"=>"https://itunes.apple.com/gb/artist/only-hits-artists-radiohead/id487955650?uo=4", 
            "artistId"=>487955650, 
            "primaryGenreName"=>"Pop", 
            "primaryGenreId"=>8022}
        ]
      end

    before(:each) {Scraper2::Itunes.stub(:get_artists_from_store) {good_itunes_api_response} }

    it "records the itunes URL" do
      artist.itunes(true).should eq "https://itunes.apple.com/gb/artist/radiohead/id657515?uo=4"
    end
    it "records the itunes ID" do
      artist.itunes_id.should eq 657515
    end
  end  

  context "when an Artist not in iTunes is given for store association" do
    let(:bad_itunes_api_response){ [] }
    before(:each) {Scraper2::Itunes.stub(:get_artists_from_store) {bad_itunes_api_response} }

    it "returns false" do
      artist.should eq false
    end
  end
end

describe "Scraper2::LastFm" do

  let(:good_api_response) do
    # Not technically accurate Radiohead info... If you were wanting that.
    { "lfm"=>{"status"=>"ok", 
        "artist"=>{"name"=>"Radiohead", 
          "mbid"=>"a74b1b7f-71a5-4011-9441-d0b5e4122711", 
          "bandmembers"=>{"member"=>[{"name"=>"Thom Yorke", "yearfrom"=>"1986"}, {"name"=>"Phil Selway", "yearfrom"=>"1986"}]}, 
          "url"=>"http://www.last.fm/music/Radiohead", 
          "image"=>["http://userserve-ak.last.fm/serve/34/3371617.jpg", 
            "http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg"], 
          "streamable"=>"1", 
          "ontour"=>"0", 
          "stats"=>{"listeners"=>"4078088", 
          "playcount"=>"374649945"}, 
          "similar"=>{"artist"=>[{"name"=>"Thom Yorke", 
          "url"=>"http://www.last.fm/music/Thom+Yorke", 
          "image"=>["http://userserve-ak.last.fm/serve/34/4556396.gif", 
            "http://userserve-ak.last.fm/serve/500/4556396/Thom+Yorke.gif"]}]}, 
          "tags"=>{"tag"=>[{"name"=>"alternative", 
            "url"=>"http://www.last.fm/tag/alternative"}, 
            {"name"=>"electronic", 
            "url"=>"http://www.last.fm/tag/electronic"}]}, 
          "bio"=>{"links"=>{"link"=>{"rel"=>"original", 
            "href"=>"http://www.last.fm/music/Radiohead/+wiki"}}, 
            "published"=>"Fri, 30 Jan 2009 20:18:28 +0000", 
            "summary"=>"BIO SUMMARY", 
            "content"=>"FULL CONTENT", 
            "placeformed"=>"Abingdon, Oxfordshire, United Kingdom", 
            "yearformed"=>"1986", 
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
    "mbid"=>nil, 
    "url"=>"http://www.last.fm/music/UKF+Drum+&+Bass", 
    "image"=>["http://userserve-ak.last.fm/serve/34/76805252.jpg", 
      "http://userserve-ak.last.fm/serve/500/76805252/UKF+Drum++Bass+gg.jpg"], 
    "streamable"=>"0", 
    "ontour"=>"0", 
    "stats"=>{"listeners"=>"230", 
    "playcount"=>"22656"}, 
    "similar"=>{}, 
    "tags"=>{"tag"=>{"name"=>"drum & bass", 
    "url"=>"http://www.last.fm/tag/drum%2B%2526%2Bbass"}}, 
    "bio"=>{"links"=>{"link"=>{"rel"=>"original", 
    "href"=>"http://www.last.fm/music/UKF+Drum+&+Bass/+wiki"}}, 
    "published"=>"Fri, 
    13 Apr 2012 16:39:25 +0000", 
    "summary"=>"\nThis is not an artist", 
    "content"=>"\nThis is not an artist"}}}}
  end

  context "when a real Artist is given for improvement" do
    before(:each) {Scraper2::LastFm.stub(:get_artist_info) {good_api_response} }
    let(:artist) {Scraper2::LastFm.improve_artist_info Artist.new()}
    it "improves the name" do
      artist.name.should eq "Radiohead"
    end
    it "improves the bio" do
      artist.bio.should eq "BIO SUMMARY"
    end

  end

  context "when a non-existent Artist is given for improvement" do
    before(:each) {Scraper2::LastFm.stub(:get_artist_info) {bad_api_response} }
    let(:artist) {Scraper2::LastFm.improve_artist_info Artist.new()}
    it "should raise" do
      expect { artist }.to raise_error(ArtistScrapeError)
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
