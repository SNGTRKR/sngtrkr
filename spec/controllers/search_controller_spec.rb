require 'spec_helper'
describe SearchController do

	search_query = "Test"
	# controller.params[:query].should_not be_nil

	describe Release do
		context "when the artist database is searched", :solr => true do
			it "returns a release json object" do
				controller.params[:r_page].should_not be_nil
				release = create(:release, name: "Test search release")
				release.index!
				release_result = Release.search do
					fulltext search_query
				end
				release_json = release_result.map do |r|
					{
						:value => r.name,
						:tokens => r.name,
						:id => r.id,
						:label => r.label_name,
						:image => r.image.small,
						:identifier => "release_search",
					}
				end
				expect(release_json.total).to eq 1
				expect(release_json['identifier']).to eq 'release_search'
				expect(release_json['value']).to eq 'Test search release'
			end
		end
	end

	describe Artist do
		context "when the release database is searched", :solr => true do
			it "returns an artist json object" do
				controller.params[:a_page].should_not be_nil
				artist = create(:artist, name: "Test search artist")
				artist.index!
				artist_result = Artist.search do
					fulltext search_query
				end
				artist_json = artist_result.map do |a|
					{
						:value => a.name,
						:token => a.name,
						:id => a.id,
						:label => a.label_name,
						:image => a.image.small,
						:identifier => "artist_search",
					}
				end
				expect(artist_result.total).to eq 1
				expect(artist_json['identifier']).to eq 'artist_search'
				expect(artist_json['value']).to eq 'Test search artist'
			end
		end
	end
end