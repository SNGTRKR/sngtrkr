# require 'spec_helper'

# describe ArtistSubJob do

# 	describe "#perform" do

# 		let(:job) { ArtistSubJob.new }
# 		let(:hash) do
# 			{
# 				access_token: "AT1234",
# 				user_id: create(:user).id,
# 				artist: JSON.parse(IO.read("spec/sample_data/fb_artist_page.json")),
# 				first_time: false,
# 			}
# 		end

# 		before(:each) {Scraper2.stub(:import_artist){ build(:artist) } }

# 		it "calls the artist scraper" do
# 			Scraper2.should_receive(:import_artist).with(hash_including(fb_data: hash[:artist])) {build(:artist)}.once
# 			job.perform(hash)
# 		end

# 		it "calls the release scraper job" do
# 			ReleaseJob.should_receive(:perform_async).once
# 			job.perform(hash)
# 		end

# 		context "when first_time is true" do

# 			it "passes that through" do
# 				Scraper2.should_receive(:import_artist).with(hash_including(first_time: true))

# 				opts = hash
# 				opts[:first_time] = true
# 				job.perform(opts)
# 			end

# 		end

# 		context "when first_time is false" do

# 			it "passes that through" do
# 				Scraper2.should_receive(:import_artist).with(hash_including(first_time: false))
# 				job.perform(hash)
# 			end

# 		end

# 	end

# end
