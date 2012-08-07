require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = User.create(:email => "bessey+3@gmail.com", :password => "password")
  end

  test "should log user in" do
    post_via_redirect "/users/sign_in",  :username => @user.email, :password => @user.password 
    assert_equal '/tl', path
  end

  
  #test "should unfollow artist" do
  #  @follow = follows(:one)
  #  assert_difference('Follow.count', -1) do
  #    visit "/artists/#{@follow.artist_id}/unfollow"
  #  end
  #  assert_redirected_to artist_path(@follow.artist_id)
  #end

end
