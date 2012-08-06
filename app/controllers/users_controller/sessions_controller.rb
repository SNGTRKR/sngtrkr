class UsersController::SessionsController < Devise::SessionsController
  
  before_filter :featured_artists, :only => [:new]
  def new
    super
  end
end
