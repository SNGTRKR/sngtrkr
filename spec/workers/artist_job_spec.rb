require 'spec_helper'

describe ArtistJob do
  
	describe "#perform" do
		before(:each) do 
			Koala::Facebook::API.any_instance.stub(:get_connections) do 
				# Contains 6 artists with FB IDs 1..6
				JSON.parse(IO.read("spec/sample_data/fb_me_music.json"))
			end

			# Avoid hitting DB by building Artists for 1,2
			Artist.stub(:find_by_fbid) do |arg|
				if arg.to_i <= 2
					build(:artist, :id => arg)
				else
					nil
				end
			end
		end

		let(:user) { create(:user) }
		let(:job) { ArtistJob.new }

		it "suggests existing artists" do
			Suggest.should_receive(:create).exactly(2).times.with(hash_including(:user_id => user.id))
			# Suggest.should_receive(:create)
			job.perform("AT1234", user.id)
		end

		it "suggests correct artists" do
			Suggest.should_receive(:create).once.with(hash_including(:user_id => user.id, :artist_id => 1))
			Suggest.should_receive(:create).once.with(hash_including(:user_id => user.id, :artist_id => 2))
			# Suggest.should_receive(:create)
			job.perform("AT1234", user.id)
		end

		it "calls ArtistSubJob for every new artist" do
			ArtistSubJob.should_receive(:perform_async).exactly(4).times
			job.perform("AT1234", user.id)
		end

	end

end
