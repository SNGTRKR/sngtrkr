require 'spec_helper'
require 'open-uri'
describe "ReleaseScraper" do

  before :each do
    @a = create(:artist)
    @rs = ReleaseScraper.new @a
    @release_count = Release.count
  end


  it "improves the name of an existing release" do
    old_release = @a.releases.build(:name => "You Should Know [Remixes]",:sd_id => 123, :date => Date.today, :scraped => true)
    old_release.save!
    
    @rs.class.improve_all
    Release.first.name.should == "You Should Know"
  end

  it "doesn't import the same release twice" do 
    releases = [
      {
        'collectionName' => "My First Album",
        'collectionViewUrl' => "test.com",
        'collectionId' => 5,
        'releaseDate' => Date.today.to_s
      }
    ]

    @rs.itunes_import(releases).should eq 1
    @rs.save_all

    Release.count.should eq @release_count + 1

    @rs.itunes_import(releases).should eq 0
    @rs.save_all

    Release.count.should eq @release_count + 1


  end

  it "gets last.fm artwork" do
    image = File.open(File.join('spec','sample_data','release_100.jpeg'))
    r = create(:release)
    r.image = image
    r.save
    Release.count.should eq @release_count + 1

    # Test for successfull image replacement
    r.image.identifier.should eq "release_100.jpeg"
    image_size = open(r.image.url).size
    @rs.class.improve_image r, :test_image => "http://www.simplyzesty.com/wp-content/uploads/2012/02/Google-logo.jpg"
    r.save
    new_image_size = open(r.image.url).size
    new_image_size.should_not == image_size

  end

  it "falls back to regular edition artwork when deluxe cannot be found" do

  end

  it "skips bad itunes releases" do

  end

  it "gets the expected releases for an XML file" do

  end

end