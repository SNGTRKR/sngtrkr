require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
  end

  test "should not create user" do

    assert_no_difference('User.count') do
      post :create, :user => @user.attributes
    end

    #assert_redirected_to user_path(assigns(:user))
  end

  test "should not show user" do
    get :show, :id => users(:two)
    assert_response :redirect, "doesn't show user if you aren't logged in"
  end

  test "should show user" do
    sign_in :user, @user
    get :show, :id => users(:two)
    assert_response :success
  end

  test "should get edit" do
    sign_in :user, @user
    get :edit, :id => @user
    assert_response :success
  end

  test "should update user" do
    sign_in :user, @user
    put :update, :id => @user, :user => {:first_name => @user.first_name, :last_name => @user.last_name}
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test "should destroy user" do
    sign_in :user, @user
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end

    assert_redirected_to users_path
  end
end
