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
      {}
    end
  end

  def after_sign_in_path_for(resource)
    (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
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
end
