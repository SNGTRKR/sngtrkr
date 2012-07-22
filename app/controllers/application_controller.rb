class ApplicationController < ActionController::Base

  # Comment out the below condition to view error 404 in development
  # unless Rails.application.config.consider_all_requests_local
  #  rescue_from Exception, with: :render_500
  #   rescue_from ActionController::RoutingError, with: :render_404
  #   rescue_from ActionController::UnknownController, with: :render_404
  #  rescue_from ActionController::UnknownAction, with: :render_404
  #  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  #end
  before_filter :authenticate_user!, :except => [:splash,:home,:sitemap]
  before_filter :timer_start
  before_filter :define_user
  
  #check_authorization  :unless => :devise_controller? # Breaks rails admin

  def define_user
      if user_signed_in?
        @user = current_user
        @app_friends = []
        @app_friends = session["friends"]
      else
        @user = nil
      end
  end  

  # This action is to ensure a user cannot simply hack a URL to view another user's area
  def self_only
    # Admins can do anything to anyone
    if current_user.role? :admin
      return true
    end
    # But users can only edit themselves
    if(params[:user_id]) then id = params[:user_id] else id = params[:id] end
    if(id == "me") then id = current_user.id else id = id.to_i end
    if(id != current_user.id)
      redirect_to :root, :flash => { :error => "You cannot change the settings of another user. If you are seeing
        this message when you are this user, contact us at support@sngtrkr.com" }
    end
  end

  def managed_artists_only
    @user = current_user

    if(params[:artist_id]) then id = params[:artist_id].to_i else id = params[:id].to_i end

    if !@user.role? :admin and (@user.managing.count.zero? or @user.managing.first.id != id)
      redirect_to :root, :notice => "I'm sorry but you can't edit artists that you don't manage! If you are seeing
        this message when you are the artist's manager, contact us at support@sngtrkr.com"
    end
  end

  
  def timer_start
    @start_time = Time.now
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  def home
    flash.keep
    if user_signed_in?
      if !current_user.roles.empty? # No roles would mean they are not a beta user
        if current_user.sign_in_count == 1 # First time user
          u = current_user
          u.sign_in_count += 1
          u.save
          return redirect_to '/intro'
        else
          return redirect_to '/tl'
        end
      end
      return redirect_to '/limbo'
    else
      redirect_to '/beta'
    end
  
  end

  def default_url_options
    if Rails.env.production?
      {:host => "sngtrkr.com"}
    else
      {:host => 'localhost'}
    end
  end

  private

  def render_404(exception)
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(exception)
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end

  def after_resending_confirmation_instructions_path_for(resource)
            flash[:notice] = 'You still need to confirm your email change. A confirmation email was sent to <strong>tom.alan.dallimore@googlemail.com</strong>. Your email will not be changed until you complete 	this step!
    		<div id="confirm-buttons">
      		<div class="o-button font-13 signika-font norm-o-pad left">Resend confirmation</div>
      	
      		<div class="clear"></div>
    		</div>'
    		redirect_to :root
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end
