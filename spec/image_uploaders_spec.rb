require 'spec_helper'
require 'open-uri'
describe "ImageUploaders" do

  before :each do
    @a = create(:artist_with_follower)
  end

  it "uploads an artist image to S3" do
    @a.image.identifier.should eq nil
    image = File.open(File.join('spec', 'sample_data', 'release_100.jpeg'))
    @a.image = image
    @a.save!
    @a.image.identifier.should_not eq nil
  end

  it "uploads a release image to S3" do
    image = File.open(File.join('spec', 'sample_data', 'release_100.jpeg'))
    release = create(:release)
    release.image.identifier.should eq nil
    release.image = image
    release.save!

    Release.count.should eq 1
    release.image.identifier.should_not eq nil
  end


end