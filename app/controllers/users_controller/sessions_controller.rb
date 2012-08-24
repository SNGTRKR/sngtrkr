class UsersController::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication

  before_filter :featured_artists, :only => [:new]

end
