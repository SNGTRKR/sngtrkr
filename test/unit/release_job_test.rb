require 'test_helper'

class ReleaseJobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "read and save release" do
    ReleaseJob.perform(1)
    assert true
  end
  
end
