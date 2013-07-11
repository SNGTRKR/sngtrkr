require 'spec_helper'
describe Sunspot do
  describe Release do
    context "when a release is saved", :solr => true do

      it "indexes the release", :integration => true do
        release = create(:release, name: "Test Solr Release")
        release.index!
        solr = Release.search do
          fulltext "Test Solr Release"
        end
        expect(solr.total).to eq 1
      end

    end

  end

  describe Artist do
    context "when an artist is saved", :solr => true do

      it "indexes the artist", :integration => true do
        artist = create(:artist, name: "Test Solr Artist")
        artist.index!
        solr = Artist.search do
          fulltext "Test Solr Artist"
        end
        expect(solr.total).to eq 1
      end

    end

  end
end