class UsersController::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    access_token = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(access_token, current_user)
    session["facebook_access_token"] = access_token
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    friends = api.get_connections("me", "friends/?fields=installed")
    app_friends = []
    app_friend_ids = []
    friends.each do |friend|
      if friend["installed"]
        u = User.where("fbid = ? ", "#{friend["id"]}").first
        if !u.nil?
          app_friends << u
          app_friend_ids << u.fbid
        end
      end
    end
    session["friends"] = app_friends
    session["friend_ids"] = app_friend_ids
    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => "Facebook")
      flash[:disappear_after] = 3000
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    # Or alternatively,
    # raise ActionController::RoutingError.new('Not Found')
  end
end