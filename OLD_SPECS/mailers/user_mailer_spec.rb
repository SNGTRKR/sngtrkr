# require 'spec_helper'
# describe UserMailer do

#   describe "#new_releases_email" do
#     before(:each) do
#       @mailer = double
#       @mailer.stub(:deliver) { true }
#     end

#     it "returns an email" do
#       expect(UserMailer.new_releases_email(
#         build(:user), "Bob, Man", [build(:release)]).class).to eq Mail::Message
#     end

#     it "embeds the artist names in the subject" do
#       expect(UserMailer.new_releases_email(
#         build(:user), "Bob, Man", [build(:release)]).subject).to include("Bob, Man")
#     end

#     it "addresses the email to the user" do
#       expect(UserMailer.new_releases_email(
#         build(:user, email: "a@b.com"), "Bob, Man", [build(:release)]).to).to include("a@b.com")
#     end

#     it "embeds the frequency adjective in the subject" do
#       expect(UserMailer.new_releases_email(
#         build(:user, email_frequency: 2), "Bob, Man", [build(:release)]).subject).to include("Weekly")
#     end

#   end

#   describe "#new_releases_email" do
#     it "returns an email" do
#       expect(UserMailer.welcome_email(build(:user)).class).to eq Mail::Message
#     end
#   end

# end

