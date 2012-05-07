class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :load, :only => [:manage, :unmanage, :follow, :unfollow, :suggest, :unsuggest, :following?, :import_artists]
  def load
    @user = current_user
  end

  def redir (artist_id)
    respond_to do |format|
      format.html { redirect_to artist_url(params[:artist_id]) }
    end
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  def self
    @user = current_user
    tl = Timeline.new(current_user.id)
    @timeline = tl.user.page params[:page]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def friends
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @user = current_user
    friends = api.get_connections("me","friends/?fields=installed")
    @app_friends = []
    friends.each do |friend|
      if friend["installed"]
        u = User.where("fbid = ? ","#{friend["id"]}").first
        if !u.nil?
        @app_friends.push u
        end
      end
    end

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
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def manage
    @user.manage params[:artist_id]
    respond_to do |format|
      format.html { redir :artist_id }
      format.json { render :json => { :response => :success } }
    end
  end

  def unmanage
    @user.unmanage params[:artist_id]
    respond_to do |format|
      format.html { redir :artist_id }
      format.json { render :json => { :response => :success } }
    end
  end

  def unfollow
    @user.unfollow params[:artist_id]
    respond_to do |format|
      format.html { redir :artist_id }
      format.json { render :json => { :response => :success } }
    end
  end

  def follow
    @user.follow params[:artist_id]
    @user.unsuggest params[:artist_id]
    # Post to facebook graph api if in production.
    if Rails.env.production?
      api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
      artist = Artist.find(params[:artist_id]);
      api.put_connections("me", "sngtrkr:track", :artist => url_for(artist))
    end
    respond_to do |format|
      format.html { redir :artist_id }
      format.json { render :json => { :response => :success } }
    end
  end

  def unsuggest
    @user.unsuggest params[:artist_id]
    redir :artist_id
  end

  def suggest
    @user.suggest params[:artist_id]
    redir :artist_id
  end

  # This page contains a list of all the Artist page's the logged in user controls.
  def managing
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @artists = []
    api.get_object("me/accounts").each do |page|
      if page["category"] == "Musician/band"
      @artists.push page
      end
    end
  end
end
