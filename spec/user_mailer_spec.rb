require 'spec_helper'
describe "UserMailer" do

  let(:user) {create(:user)}
  let(:artist) {create(:artist)}

  context "when a release is added" do

    it "emails followers" do
      user.followed_artists << artist
      create(:release, artist: artist)
      email = UserMailer.new_releases(user)
      email.should_not eq false
      email.body.to_s.length.should be > 0
    end

    it "does not email non followers" do
      user.followed_artists << artist
      user2 = create(:user)
      create(:release, artist: artist)
      email = UserMailer.new_releases(user2)
      email.is_a?(ActionMailer::Base::NullMail).should eq true
    end

    it "marks sent notifications as sent" do
      Notification.count.should eq 0
      user.followed_artists << artist
      create(:release, artist: artist)
      Notification.first.sent.should eq false
      UserMailer.new_releases(user)

      Notification.first.sent.should eq true
      sent_ago = Time.now - Notification.first.sent_at
      sent_ago.should < 10.seconds
    end

    it "leaves unsent notifications as unsent" do
      Notification.count.should eq 0
      user.followed_artists << artist
      user2 = create(:user)
      user2.followed_artists << artist
      create(:release, artist: artist)
      Notification.where(:sent => true).length.should eq 0
      UserMailer.new_releases(user)

      Notification.unsent.first.user.should eq user2
      Notification.sent.first.user.should eq user
    end

  end

  context "when there are no new releases" do
    it "does not email anyone" do
      user.followed_artists << artist
      email = UserMailer.new_releases(user)
      email.is_a?(ActionMailer::Base::NullMail).should eq true
    end

    it "does not resend sent notifications" do
      user.followed_artists << artist
      create(:release, artist: artist)
      UserMailer.new_releases(user)
      # Resend again, but now with notification marked as sent
      email = UserMailer.new_releases(user)
      email.is_a?(ActionMailer::Base::NullMail).should eq true
    end
  end

end