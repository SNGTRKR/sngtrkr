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
		end
	end

	context "when an old release is saved" do
		it "notifies no one" do
		end
	end

	context "when an existing release is saved" do
		it "notifies no one" do
		end
	end

end