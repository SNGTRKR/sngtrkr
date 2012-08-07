class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :self_only, :except => [:show, :timeline, :self, :local_new]
  before_filter :authenticate_user!, :except => [:local_new]
  
  load_and_authorize_resource :except => [:local_new]

  def index
    @users = User.limit(50).all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def timeline
    @user = current_user

    tl = Timeline.new(current_user.id)
    @timeline = tl.user(params[:page])
    @timeline = @timeline # Reverse so farthest right release is the newest, but pages index from the newest page.
    respond_to do |format|
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show  
    # Check if this is your page
    if current_user.id == params[:id].to_i
      api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
      @user = current_user
      if @user.managing.count > 0
        @artist = @user.managing.first
        @trackers = @artist.followed_users.count
      end
      @following = @user.following
      respond_to do |format|
        format.html { render '/users/self' }
      end
      
    else
    
      @friend = User.find(params[:id])
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

  def friends
    @app_friends = []
    @app_friends = session["friends"]
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
          notice = 'Success! Your changes have been saved.'
        else
          notice = 'Success! Your changes have been saved. You must confirm your email address before it will register in the system. Please check your email now for a confirmation link.'
        end
        format.html { redirect_to edit_user_path(@user), :flash => { :success => notice } }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
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

  def manage
    current_user.manage_artist params[:id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:id])}
      format.json { render :json => { :response => :success } }
    end
  end

  # This page contains a list of all the Artist page's the logged in user controls.
  def managing
    # if a user is already managing an artist, redirect to their page
    if current_user.managing.count > 0
      @artist = current_user.managing.first
      return redirect_to edit_artist_path(@artist)
    end
    
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @manageable = []
    api.get_object("me/accounts").each do |page|
      if page["category"] == "Musician/band"
        artist = Artist.where("fbid = ?", page["id"]).first
        if artist.nil?
        next
        else
        @manageable << artist
        end
      end
    end
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
  
    def unmanage_confirm
    respond_to do |format|
      format.html { render :unmanage_confirm, :layout => false }
      format.json { head :no_content }
    end
  end
  
  def unmanage
    current_user.managing.delete(current_user.managing.first)
    redirect_to :root
  end

  def local_new

  end

end
