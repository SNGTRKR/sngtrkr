require 'spec_helper'
require 'scraper_2'
require 'open-uri'

include Scraper2

describe "ItunesRss" do

  before :all do
    @rss_items = ItunesRss.fetch_releases(File.open('spec/sample_data/itunes_rss_10.xml'))
  end

  it "converts itunes rss feed to object" do
    @rss_items[0]["title"].should eq "People Like Me - Kassidy"
  end

  it "drops artists not in the db" do
    # This ID is in the XML file
    create(:artist,:itunes_id => 1234)
    remaining = ItunesRss.remove_where_no_artist(@rss_items)
    remaining.length.should eq 1
    remaining[0]["artistItunesId"].should eq 1234
  end

  # Poor test, need to improve by stubbing iTunes lookup.
  it "converts generic release objects to Releases" do
    releases = ItunesRss.convert(@rss_items)
    releases.length.should > 1
  end

end