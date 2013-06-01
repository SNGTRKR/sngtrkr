class UsersController::RegistrationsController < Devise::RegistrationsController
  before_filter :check_permissions, :only => [:timeline]
  skip_before_filter :require_no_authentication

  before_filter :featured_artists, :only => [:new]

  def check_permissions
    authorize! :create, resource
  end

  def destroy
    resource.soft_delete(params[:leave_reason])
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  def update
    @user = User.find(current_user.id)

    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      params[:user].delete("current_password")
    end

    if params[:user][:password]
      if @user.update_with_password(params[:user])
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to user_path(current_user)
      else
        render "edit"
      end
    else
      if @user.update_attributes(params[:user])
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to user_path(current_user)
      else
        render "edit"
      end
    end
  end

end
