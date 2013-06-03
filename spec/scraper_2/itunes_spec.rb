require 'spec_helper'
describe Scraper2::Itunes do
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