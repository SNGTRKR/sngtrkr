require 'spec_helper'
describe Trucker do

  before do
    User.delete_all
    Notification.delete_all
  end

  before(:each) do
    @mailer = double("Mail::Message")
    @mailer.stub(:deliver) { true }
    UserMailer.stub(:new_releases_email) { @mailer }
  end

  let(:user) { create(:user) }
  let(:artist) { create(:artist) }
  let(:release) { create(:release, artist: artist, date: 1.day.ago) }

  context "when a release is added" do

    it "emails followers" do
      user.followed_artists << artist
      release
      @mailer.should_receive(:deliver).once
      Trucker.deliver_new_releases_email(user)
    end

    it "does not email non followers" do
      user.followed_artists << artist
      user2 = create(:user)
      release
      @mailer.should_not_receive(:deliver)
      Trucker.deliver_new_releases_email(user2)
    end

    it "marks sent notifications as sent" do
      user.followed_artists << artist
      release
      Notification.first.sent.should eq false
      Trucker.deliver_new_releases_email(user)

      Notification.first.sent.should eq true
      sent_ago = Time.now - Notification.first.sent_at
      sent_ago.should < 10.seconds
    end

    it "leaves unsent notifications as unsent" do
      user.followed_artists << artist
      user2 = create(:user)
      user2.followed_artists << artist
      release
      expect(Notification.where(:sent => true).count).to eq 0
      Trucker.deliver_new_releases_email(user)

      Notification.unsent.first.user.should eq user2
      Notification.sent.first.user.should eq user
    end

  end

  context "when there are no new releases" do
    it "does not email anyone" do
      user.followed_artists << artist
      @mailer.should_not_receive(:deliver)
      Trucker.deliver_new_releases_email(user)
    end

    it "does not resend sent notifications" do
      user.followed_artists << artist
      release
      @mailer.should_receive(:deliver).once
      Trucker.deliver_new_releases_email(user)
      # Resend again, but now with notification marked as sent
      Trucker.deliver_new_releases_email(user)
    end
  end

end