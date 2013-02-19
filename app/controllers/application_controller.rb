class ApplicationController < ActionController::Base

  before_filter :authenticate_user!, :except => [:splash,:home,:sitemap]
  before_filter :featured_artists, :only => [:home,:new]
  before_filter :define_user, :except => [:search]
  
  #check_authorization  :unless => :devise_controller? # Breaks rails admin

  def define_user
      if user_signed_in?
        @user = current_user
        @app_friends = []
        @app_friends = session["friends"]
        @activities = User.recent_activities session["friends"]
      else
        @activities = []
        @user = nil
      end
  end  

  # This action is to ensure a user cannot simply hack a URL to view another user's area
  def self_only
    # Admins can do anything to anyone
    if current_user and current_user.role? :admin
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

  # For use in the featured content partial
  def featured_artists
    count = 5
    top_artists = Artist.select('artists.id').joins(:follow).group('artists.id').having("count(follows.id) > #{count}")
    @latest_releases = Release.order("date DESC").where(:artist_id => top_artists).limit(4)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  def home
    flash.keep
    if user_signed_in?
      if current_user.sign_in_count == 1 # First time user
        u = current_user
        u.sign_in_count += 1
        u.save
        return redirect_to '/intro'
      else
        return redirect_to '/tl'
      end
    end
    render 'pages/home', :layout => 'no_sidebar'
  end

  def default_url_options
    if Rails.env.production?
      {:host => "sngtrkr.com"}
    else
      {:host => 'localhost'}
    end
  end

  private

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
