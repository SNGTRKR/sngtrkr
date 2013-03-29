require 'spec_helper'
require 'open-uri'
describe "Paperclip" do

  before :each do 
    @a = create(:artist)
  end

  it "uploads an artist image to S3" do
    image = File.open(File.join('spec','sample_data','release_100.jpeg'))
    @a.image = image
    @a.save!
    image = @a.image :original
    (open(image).is_a? StringIO).should == true
  end

  it "uploads a release image to S3" do
    image = File.open(File.join('spec','sample_data','release_100.jpeg'))
    release = @a.releases.build(attributes_for(:release))
    release.image = image
    release.save

    Release.count.should eq 1
    image = release.image :original
    (open(image).is_a? StringIO).should eq true
  end


end