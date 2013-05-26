require 'spec_helper'
describe "UserMailer" do

	before :each do
		@user = create(:user)
		@artist = create(:artist)
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

		it "marks sent notifications as sent" do
			Notification.count.should eq 0
			@user.following << @artist
			@artist.releases.build(attributes_for(:release)).save
			Notification.first.sent.should eq false
			UserMailer.new_releases(@user)
	
			Notification.first.sent.should eq true
			sent_ago = Time.now - Notification.first.sent_at
			sent_ago.should < 10.seconds
		end

		it "leaves unsent notifications as unsent" do
			Notification.count.should eq 0
			@user.following << @artist
			@user2 = create(:user)
			@user2.following << @artist
			@artist.releases.build(attributes_for(:release)).save
			Notification.where(:sent => true).length.should eq 0
			UserMailer.new_releases(@user)
	
			Notification.where(:sent => false).first.user.should eq @user2
			Notification.where(:sent => true).first.user.should eq @user
		end

	end

	context "when there are no new releases" do
		it "does not email anyone" do
			@user.following << @artist
			email = UserMailer.new_releases(@user)
			email.is_a?(ActionMailer::Base::NullMail).should eq true
		end

		it "does not resend sent notifications" do
			@user.following << @artist
			release = @artist.releases.build(attributes_for(:release))
			release.save
			UserMailer.new_releases(@user)
			# Resend again, but now with notification marked as sent
			email = UserMailer.new_releases(@user)
			email.is_a?(ActionMailer::Base::NullMail).should eq true
		end
	end

end