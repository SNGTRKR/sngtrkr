class ErrorsController < ApplicationController

  skip_before_filter :authenticate_user!

  def error_404
    @not_found_path = params[:not_found]
  end

  def error_500
  end
end
