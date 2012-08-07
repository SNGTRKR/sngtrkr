require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  setup do
    @follow = follows(:one)
    @user = users(:two)
    sign_in :user, @user
  end

  test "should create follow" do
    assert_difference('Follow.count') do
      post :create, :artist_id => 2, :follow => {:user_id => @user}
    end

    assert_response :success
  end

end
