require 'spec_helper'
describe "Release" do

	context "when a new release is saved" do
		it "notifies only users following the artist" do
		end

		it "removes unnecessary metadata from title" do
			release = create(:release, :name => "Izzy Pop (Remixes)")
			release.save
			release.name.should eq "Izzy Pop"

			release = create(:release, :name => "Dizzy Trap (Radical Remixes)")
			release.save
			release.name.should eq "Dizzy Trap (Radical Remixes)"

			release = create(:release, :name => "Izzy Pop (Radical Remixes) EP")
			release.save
			release.name.should eq "Izzy Pop (Radical Remixes)"

			release = create(:release, :name => "Riggy Pop - EP")
			release.save
			release.name.should eq "Riggy Pop"
		end

		it "combines data of duplicates together" do
			# Factory generates two releases one day after another
			rc = Release.count
			a = create(:artist)
			create(:release, :artist => a, :name => "SameName", :itunes_id => 456)
			r = create(:release, :artist => a, :name => "SameName", :sd_id => 123)
			Release.count.should eq (rc+1)
			r.sd_id.should eq 123
			r.itunes_id.should eq 456
		end

		it "does not merge nearby non-duplicates" do
			# Factory generates two releases one day after another
			rc = Release.count
			a = create(:artist)
			create(:release, :name => "Release A", :artist => a)
			create(:release, :name => "Release B", :artist => a)
			Release.count.should eq (rc+2)
		end
	end

	context "when an old release is saved" do
		it "notifies no one" do
			a = create(:artist_with_follower)
			create(:release, :date => 1.month.ago, :artist => a)
			User.count.should eq 1
			Follow.count.should eq 1
			Notification.count.should eq 0
		end
	end

	context "when an existing release is saved" do
		it "notifies no one" do
			a = create(:artist_with_follower)
			r = create(:release, :artist => a)
			Notification.destroy_all
			r.save
			Notification.count.should eq 0
		end
	end

end