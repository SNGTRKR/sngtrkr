class Error404 < StandardError; end

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Error404, :with => :render_404
  def render_404
    respond_to do |type|
      type.html { render :template => "errors/error_404", :status => 404, :layout => 'error' }
      type.all  { render :nothing => true, :status => 404 }
    end
    true
  end
end
