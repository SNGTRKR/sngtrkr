require 'spec_helper'
describe "UserMailer" do

	before :each do
		@user = create(:user)
		@artist = create(:artist_with_follower)
	end

	context "when a release is added" do
		it "emails followers" do
			@user.following << @artist
			release = @artist.releases.build(attributes_for(:release))
			release.save
			email = UserMailer.new_releases(@user)
			email.should_not eq false
			email.body.to_s.length.should be > 0
		end

		it "does not email non followers" do
			@user.following << @artist
			@user2 = create(:user)
			release = @artist.releases.build(attributes_for(:release))
			release.save
			email = UserMailer.new_releases(@user2)
			email.is_a?(ActionMailer::Base::NullMail).should eq true
		end
	end

	context "when there are no new releases" do
		it "does not email anyone" do
			@user.following << @artist
			email = UserMailer.new_releases(@user)
			email.is_a?(ActionMailer::Base::NullMail).should eq true
		end
	end

end