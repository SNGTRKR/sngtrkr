require 'spec_helper'

describe User do
  describe ".release_notifications" do
    describe ".current" do

      it "fetches the current releases for user" do
        a = create(:artist)
        u = create(:user)
        u.followed_artists << a
        r1 = create(:release, artist: a, date: 10.days.ago)
        # I'm in the future, shouldn't contain me!
        r2 = create(:release, artist: a, date: Date.today+10)
        expect(u.release_notifications.current).to eq [r1]
      end
    end

    describe ".artist_names" do

      it "concatenates artists for user" do
        a = create(:artist, name: "Fred")
        a2 = create(:artist, name: "Bob")
        u = create(:user)
        u.followed_artists << [a, a2]
        r1 = create(:release, artist: a, date: 10.days.ago)
        # I'm in the future, shouldn't contain me!
        r2 = create(:release, artist: a2, date: 10.days.ago)
        expect(u.release_notifications.artist_names).to eq "Fred, Bob"
      end

    end
  end
end
