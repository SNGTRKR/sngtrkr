#encoding: utf-8
require 'spec_helper'
describe Scraper2::Itunes do

  describe "#scrape_artist" do
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

  describe "#scrape_releases_for" do

    let(:itunes_api_response) do
      [
        {
          "wrapperType"=>"collection",
          "collectionType"=>"Album",
          "artistId"=>10,
          "collectionId"=>1,
          "collectionName"=>"In Between Dreams (Bonus Track Version)",
          "collectionViewUrl"=>"https://itunes.com/super_good_album1",
          "releaseDate"=>"2005-03-01T08:00:00Z",
          "primaryGenreName"=>"Rock"
        },
        {
          "wrapperType"=>"collection",
          "collectionType"=>"Album",
          "artistId"=>10,
          "collectionId"=>2,
          "collectionName"=>"Sleep Through the Static",
          "collectionViewUrl"=>"https://itunes.com/super_good_album2",
          "releaseDate"=>"2008-02-04T08:00:00Z",
          "primaryGenreName"=>"Rock"
        },
        {
          "wrapperType"=>"collection",
          "collectionType"=>"Album",
          "artistId"=>10,
          "collectionId"=>3,
          "collectionName"=>"From Here to Now to You",
          "collectionViewUrl"=>"https://itunes.com/super_good_album3",
          "releaseDate"=>"2013-09-17T07:00:00Z",
          "primaryGenreName"=>"Rock"
        }
      ]
    end
    let(:artist) { build(:artist, itunes_id: 10, id: 5) }
    before(:each) {Scraper2::Itunes.stub(:get_releases_from_store) {itunes_api_response} }

    it "returns as many releases as body contained" do 
      Itunes.scrape_releases_for(artist).length.should eq 3
    end

    it "returns [] when no releases for artist" do
      Scraper2::Itunes.stub(:get_releases_from_store) { [] }
      Itunes.scrape_releases_for(artist).length.should eq 0
    end

    context "for a release in the result set" do
      let(:first_release) { Itunes.scrape_releases_for(build(:artist, itunes_id: 10, id: 5))[0] }
      it "fills the artist_id" do
        first_release.artist_id.should eq 5
      end

      it "fills the itunes url" do
        first_release.itunes(true).should eq "https://itunes.com/super_good_album1"
      end

      it "fills the itunes_id" do
        first_release.itunes_id.should eq 1
      end

      it "fills the name" do
        first_release.name.should eq "In Between Dreams (Bonus Track Version)"
      end

      it "fills the date" do
        date_diff = first_release.date.to_date.mjd - Date.strptime("2005-03-01T08:00:00Z").mjd
        date_diff.should eq 0
      end

      it "marks the release scraped" do
        first_release.scraped.should eq true
      end
    end
  end
end