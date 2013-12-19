require 'spec_helper'
describe Follow do

    # creates new suggest with artist id from the new artist
    let(:suggest) { create(:suggest, artist_id: [artist]) }
    # creates new artist
    let(:artist) { create(:artist_with_follower) }

    its(:suggest) { should include(artist) }
 
    # method responses
    it { should respond_to(:destroy_unfollowed_artist) }
    it { should respond_to(:delete_suggestion) }
 
end