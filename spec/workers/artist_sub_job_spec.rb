require 'spec_helper'

describe ArtistSubJob do

	describe "#perform" do

		let(:job) { ArtistSubJob.new }
		let(:hash) do
			{
				access_token: "AT1234",
				user_id: create(:user).id,
				artist: JSON.parse(IO.read("spec/sample_data/fb_artist_page.json")),
				first_time: false,
			}
		end

		it "calls the facebook scraper" do
			Scraper2::Facebook.should_receive(:scrape_artist).once.and_call_original	
			job.perform(hash)
		end

		it "saves the artist to the db" do
			Artist.any_instance.should_receive(:save).once.and_call_original	
			job.perform(hash)
		end

		it "calls the release scraper job" do
			ReleaseJob.should_receive(:perform_async).once
			job.perform(hash)
		end

		context "when first_time is true" do

			it "follows the artist" do
				Follow.should_receive(:create).once

				opts = hash
				opts[:first_time] = true
				job.perform(opts)
			end

		end

		context "when first_time is false" do

			it "suggests the artist" do
				Suggest.should_receive(:create).once

				job.perform(hash)
			end

		end

	end

end
