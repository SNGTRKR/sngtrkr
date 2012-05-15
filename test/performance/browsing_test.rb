require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }
  def test_homepage
    get '/'
  end

  def test_artist
    get '/artists/1'
  end

  def test_logged_in
    #sign_in @user
    get '/users/self'
  end
end
