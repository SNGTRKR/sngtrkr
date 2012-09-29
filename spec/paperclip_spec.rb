require 'spec_helper'
require 'open-uri'
describe "Paperclip" do

  before :all do 
    Artist.destroy_all
    Release.destroy_all
    @a = Artist.new(:name => "testarooni", :sdid => 1, :fbid => "123", :itunes_id => 4)
    @a.save!
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
    r = Release.new(:name => "testarooni", :sd_id => 1, :itunes_id => 4, :image => image, :artist_id => @a.id, :date => Date.today)
    r.save!
    Release.count.should == 1
    image = @a.image :original
    (open(image).is_a? StringIO).should == true
  end


end