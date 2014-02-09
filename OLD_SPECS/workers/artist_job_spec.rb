# require 'spec_helper'

# describe ArtistJob do
  
# 	describe "#perform" do
# 		before(:each) do 
# 			Scraper2::Facebook.stub(:get_all_artists_for_user) do 
# 				# Contains 6 artists with FB IDs 1..6
# 				JSON.parse(IO.read("spec/sample_data/fb_me_music.json"))
# 			end

# 			# Avoid hitting DB by building Artists for 1,2
# 			Artist.stub(:find_by_fbid) do |arg|
# 				if arg.to_i <= 2
# 					build(:artist, :id => arg)
# 				else
# 					nil
# 				end
# 			end
# 		end

# 		let(:user) { create(:user) }
# 		let(:job) { ArtistJob.new }

# 		it "suggests existing artists" do
# 			Suggest.should_receive(:create).exactly(2).times.with(hash_including(:user_id => user.id))
# 			# Suggest.should_receive(:create)
# 			job.perform("AT1234", user.id)
# 		end

# 		it "suggests correct artists" do
# 			Suggest.should_receive(:create).once.with(hash_including(:user_id => user.id, :artist_id => 1))
# 			Suggest.should_receive(:create).once.with(hash_including(:user_id => user.id, :artist_id => 2))
# 			# Suggest.should_receive(:create)
# 			job.perform("AT1234", user.id)
# 		end

# 		it "calls ArtistSubJob for every new artist" do
# 			ArtistSubJob.should_receive(:perform_async).exactly(4).times
# 			job.perform("AT1234", user.id)
# 		end

# 		it "passes the correct data into ArtistSubJob" do
# 			artist = JSON.parse(IO.read("spec/sample_data/fb_me_music.json"))[3]
# 			ArtistSubJob.should_receive(:perform_async).with(hash_including(
# 				access_token: "AT1234",
# 				user_id: user.id,
# 				artist: artist,
# 				first_time: false
# 				)).at_least(1).times
# 			ArtistSubJob.should_receive(:perform_async).exactly(3).times
# 			job.perform("AT1234", user.id)
# 		end

# 	end

# end
