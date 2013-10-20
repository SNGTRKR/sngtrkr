class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :user
      root_url
    else
      root_url
      # new_user_registration_path
    end
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end