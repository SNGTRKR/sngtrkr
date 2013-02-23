class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :self_only, :except => [:show, :timeline, :self, :new, :create]
  before_filter :authenticate_user!, :except => [:new]
  load_and_authorize_resource :except => [:new]

  def index
    @users = User.limit(50).all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def timeline
    @user = current_user
    params[:page] ||= 0
    @timeline = Timeline.user(current_user.id, params[:page])
    respond_to do |format|
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show  
    # Check if this is your page
    if current_user.id == params[:id].to_i
      @user = current_user
      @following = @user.following.joins(:follow).select('artists.*, COUNT(follows.artist_id) as followers').group('artists.id').ordered.page(params[:page])
      respond_to do |format|
        format.html { render '/users/self' }
      end
      
    else
    
      @friend = User.find(params[:id])
      @following = @friend.following.ordered.page(params[:page])
      # Do we want to stop users viewing other users if they aren't facebook friends?
      #      if !current_user.friends_with? @friend, session["friend_ids"]
      #        return redirect_to :root, :error => "You do not have permissions to view this user"
      #      end
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end

  def self
    redirect_to "/users/#{current_user.id}"
  end

  # Allows a user to see their profile from an oustide perspective
  def public
      @friend = User.find(params[:id])
      render :show
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if !params[:user][:email]
          notice = '<strong>Success!</strong> Your changes have been saved.'
        else
          notice = '<strong>Success!</strong> Your changes have been saved. You must confirm your email address before it will register in the system. Please check your email now for a confirmation link.'
        end
        format.html { redirect_to user_path(@user, :page => 'edit'), :flash => { :success => notice } }
        format.json { head :no_content }
      else
      format.html { redirect_to user_path(@user, :page => 'edit'), :flash => { :error => "There was an error with the changes you tried to make. Please try again." } }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json

  def destroy_confirm
    respond_to do |format|
      format.html { render :delete_confirm, :layout => false }
      format.json { head :no_content }
    end
  end
  
  def destroy      
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, :notice => 'Account successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_with_reason
    Rails.logger.info(params)
    @user = User.find(params[:id])
    @user.leave_reason = params[:leave_reason]
    @user.soft_delete
    sign_out(@user)
    redirect_to :root, :notice => "<p>Your account has been removed from the site. Note that we will retain your data privately, so if you change your mind, you can rejoin anytime. If you wish to have your data completely removed, please email support@sngtrkr.com</p>"
  end

  def recommend
    @user = current_user
    if @user.sign_in_count <= 2
      @first_time = true
    else
      @first_time = false
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def local_new

  end

end
