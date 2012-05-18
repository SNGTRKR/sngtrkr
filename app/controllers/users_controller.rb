class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :load, :only => [:manage, :unmanage, :follow, :unfollow, :suggest, :unsuggest, :following?, :import_artists,:friends]
  def load
    @user = current_user
  end

  def redir (artist_id)
    respond_to do |format|
      format.html { redirect_to artist_url(params[:id]) }
    end
  end

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def timeline
    # FIXME: This works, but it shouldn't really be in this 
    if(current_user.sign_in_count == 1)
      current_user.sign_in_count = 2
      current_user.save
      return redirect_to recommend_user_path(current_user)
    end

    tl = Timeline.new(current_user.id)
    @timeline = tl.user.page params[:page]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @friend = User.find(params[:id])
    if !current_user.friends_with? @friend, session["friend_ids"]
      flash[:error] = "You do not have permissions to view this user"
      return redirect_to "/"
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def self
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @user = current_user
    if @user.managing.count > 0
      @artist = Artist.find(@user.managing.first.artist_id)
      @trackers = @artist.followed_users.count
    end
    @following = @user.following
    respond_to do |format|
      format.html # show.html.erb
    end
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
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def manage
    @user.manage params[:id]
    respond_to do |format|
      format.html { redir :id }
      format.json { render :json => { :response => :success } }
    end
  end

  def unmanage
    @user.unmanage params[:id]
    respond_to do |format|
      format.html { redir :id }
      format.json { render :json => { :response => :success } }
    end
  end

  def unfollow
    @user.unfollow params[:id]
    respond_to do |format|
      format.html { redir :id }
      format.json { render :json => { :response => :success } }
    end
  end

  def follow
    @user.follow params[:id]
    @user.unsuggest params[:id]
    # Post to facebook graph api if in production.
    if Rails.env.production?
      api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
      artist = Artist.find(params[:id]);
      begin
        api.put_connections("me", "sngtrkr:track", :artist => url_for(artist))
      rescue
        logger.warning "Failed to track #{artist.name} for #{@user.id}"
      end
    end
    @artist = Artist.find(@user.suggested[6].id)
    respond_to do |format|
      format.html { redir :id }
      format.json { render("artists/show.json") }
    end
  end

  def unsuggest
    @user.unsuggest params[:id]
    redir :id
  end

  def suggest
    @user.suggest params[:id]
    redir :id
  end

  # This page contains a list of all the Artist page's the logged in user controls.
  def managing
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @manageable = []
    @managing = []
    api.get_object("me/accounts").each do |page|
      if page["category"] == "Musician/band"
        artist = Artist.where("fbid = ?", page["id"]).first
        if current_user.managing.count > 0 and current_user.managing.first.artist_id == page["db_id"]
        @managing.push artist
        else
        @manageable.push artist
        end
      end
    end
  end

  def manage_confirm
    render :layout => false
  end

  def recommend
    @user = current_user
    respond_to do |format|
      format.html
      format.json
    end
  end

end
