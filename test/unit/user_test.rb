require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "admins can do whatever they like" do
    user = users(:one)
    ability = Ability.new(user)
    assert ability.can?(:destroy, user), "admin can't destroy themself"
    assert ability.can?(:destroy, Release.new), "admin can't destroy releases"
  end

  test "regular users have limited permissions" do
    user = users(:two)
    ability = Ability.new(user)
    assert ability.cannot?(:destroy, artists(:one)), "user can destroy artists"
    assert ability.cannot?(:destroy, Release.new), "user can destroy releases"
  end

end
