# encoding: utf-8
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
          expect { artist }.to raise_error(ValidationError)
        end
      end

    end
  end

  describe "#artist_image" do
    let(:artist_image) {Scraper2::LastFm.artist_image build(:artist).name}
    context "when a good name is given" do
      it "finds an image" do
        tmp_file = Tempfile.new("foo")
        Scraper2::LastFm.stub(:get_artist_info) {good_api_response}
        Scraper2::LastFm.stub(:open_image).with("http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg") {tmp_file}
        Scraper2::LastFm.should_receive(:open_image).with("http://userserve-ak.last.fm/serve/500/3371617/Radiohead+rhpics3pt4.jpg").once
        expect(artist_image).to eq tmp_file
      end
    end

    context "when a bad name is given" do
      it "returns nil" do
        Scraper2::LastFm.stub(:get_artist_info) {bad_api_response}
        expect(artist_image).to eq nil
      end
    end

    context "when rubbish is given" do
      it "returns ArgumentError" do
        expect{Scraper2::LastFm.artist_image 4}.to raise_error ArgumentError
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
        tmp_file = Tempfile.new("foo")
        Scraper2::LastFm.stub(:get_album_info) {good_api_response}
        Scraper2::LastFm.stub(:open_image).with("http://userserve-ak.last.fm/best_image.png") {tmp_file}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq tmp_file
      end
    end

    context "when an imageless response is returned" do
      it "returns nil" do
        response = bad_api_response
        response.delete("image")
        Scraper2::LastFm.stub(:get_album_info) {response}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq nil
      end
    end

    context "when an image URL-less response is returned" do
      it "returns nil" do
        response = bad_api_response
        response["image"] = [{"size"=>"small"}, {"size"=>"mega"}]
        Scraper2::LastFm.stub(:get_album_info) {response}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq nil
      end
    end

    context "when a bad response is returned" do
      it "returns nil" do
        Scraper2::LastFm.stub(:get_album_info) {bad_api_response}
        expect(Scraper2::LastFm.release_image("Pink Floyd", "The Wall")).to eq nil
      end
    end
  end

  describe "integration" do
    it "returns valid artist info", :integration => true do
      artist_info = Scraper2::LastFm.send(:get_artist_info, "Radiohead")
      expect(artist_info["name"]).to eq "Radiohead"
    end

    it "returns valid album info", :integration => true do
      album_info = Scraper2::LastFm.send(:get_album_info, "Radiohead", "In Rainbows")
      expect(album_info["name"]).to eq "In Rainbows"
    end

    it "handles ASCII crazy artists", :integration => true do
      artist_info = Scraper2::LastFm.send(:get_artist_info, "Justicé")
      expect(artist_info["name"]).to eq "Justicé"
    end

  end

end
