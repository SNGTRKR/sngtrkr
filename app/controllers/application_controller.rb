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
  
  check_authorization  :unless => :devise_controller?
  
  def timer_start
    @start_time = Time.now
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
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
