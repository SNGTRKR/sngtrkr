require 'spec_helper'
describe "UserMailer" do

	before :each do
		@user = create(:user)
		@artist = create(:artist)
	end

	context "when a release is added" do
		it "emails them" do
			@user.following << @artist
			release = @artist.releases.build(attributes_for(:release))
			release.save
			email = UserMailer.new_releases(@user)
			email.should_not eq false
			email.body.to_s.length.should be > 0
		end
	end

	context "when there are no new releases" do
		it "does not email them" do
			@user.following << @artist
			email = UserMailer.new_releases(@user)
			email.is_a?(ActionMailer::Base::NullMail).should eq true
		end
	end

end