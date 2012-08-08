require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "new_releases" do

    # Send the email, then test that it got queued
    mail = UserMailer.new_releases(users(:one),1)

    @expected.from    = 'noreply@sngtrkr.com'
    @expected.to      = 'bessey@gmail.com'
  
    assert_not_nil assigns(:releases)
    assert_not_nil assigns(:date_adjective)
  
  end

end
