require 'spec_helper'
require 'open-uri'
describe CarrierWave::Uploader do

  before do
    ArtistUploader.enable_processing = true
    ReleaseUploader.enable_processing = true
  end

  let(:image) { File.open(File.join('spec', 'sample_data', 'release_100.jpeg')) }
  let(:artist) { create(:artist_with_follower) }
  let(:release) { create(:release) }

  context "when an image holding record is created" do

    it "has no image (Artist)", :integration => true do
      artist.image.identifier.should eq nil
    end

    it "has no image (Release)", :integration => true do
      release.image.identifier.should eq nil
    end

  end

  context "when an image is added to a record" do

    it "saves the image (Artist)", :integration => true do
      artist.image = image
      artist.save!
      expect(open(artist.image.file.file).is_a?(File)).to eq true
    end

    it "saves a release image", :integration => true do
      release.image = image
      release.save!
      expect(open(release.image.file.file).is_a?(File)).to eq true
    end

    it "can access the image over HTTP", :integration => true do
      artist.image = image
      artist.save!
      image_file = open("http://localhost:3000#{Artist.last.image.small}")
      expect(image_file.is_a?(StringIO)).to eq true
    end

  end


  after do
    ArtistUploader.enable_processing = false
    ReleaseUploader.enable_processing = false
  end


end