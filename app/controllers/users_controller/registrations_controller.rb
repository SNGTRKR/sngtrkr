class UsersController::RegistrationsController < Devise::RegistrationsController
  before_filter :check_permissions, :only => [:new, :create, :cancel, :timeline]
  skip_before_filter :require_no_authentication
 
  def check_permissions
    authorize! :create, resource
  end

  def destroy
    resource.soft_delete
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(resource)
  end

end
