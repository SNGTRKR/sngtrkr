class BetaUsersController < ApplicationController
  # GET /beta_users
  # GET /beta_users.json
  skip_authorization_check
  before_filter :authenticate_user!, :except => [:create, :new]
  def index
    @beta_users = BetaUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beta_users }
    end
  end

  # GET /beta_users/new
  # GET /beta_users/new.json
  def new
    if user_signed_in?
      return redirect_to '/tl'
    end
    @beta_user = BetaUser.new

    respond_to do |format|
      format.html
    end
  end

  # POST /beta_users
  # POST /beta_users.json
  def create
    @beta_user = BetaUser.new(params[:beta_user])

    respond_to do |format|
      if @beta_user.save
        UserMailer.beta_email(@beta_user).deliver
        flash.now[:notice] = 'Thank you for signing up to the SNGTRKR beta release. Please check your inbox for a confirmation email.'
        @beta_user = BetaUser.new()
        format.html { render action: "new" }
      else
        format.html { render  action: "new" }
      end
    end
  end

end
