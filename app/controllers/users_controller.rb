class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :self_only, :only => [:edit, :manage, :managing, :unmanage, :friends]
  # This action is to ensure a user cannot simply hack a URL to view another user's area
  def self_only
    @user = current_user
    if(params[:id].to_i != current_user.id)
      redirect_to :root, :error => "You should not try to tamper with other users things..."
    end
  end
  
  def index
    @users = User.limit(50).all
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
    @timeline = tl.user(params[:page])
    @timeline = @timeline.reverse # Reverse so farthest right release is the newest, but pages index from the newest page.
    respond_to do |format|
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @friend = User.find(params[:id])
    @your_friends = User.where(:fbid => session["friend_ids"])
    @their_friends = User.where(:fbid => session["friend_ids"])
    if !current_user.friends_with? @friend, session["friend_ids"]
      return redirect_to :root, :error => "You do not have permissions to view this user"
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def self
    api = Koala::Facebook::API.new(session["facebook_access_token"]["credentials"]["token"])
    @user = current_user
    if @user.managing.count > 0
      @artist = @user.managing.first
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

  def destroy_with_reason
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.soft_delete
    #set_flash_message :notice, :destroyed
    sign_out_and_redirect(@user)
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def manage
    current_user.manage_artist params[:id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:id])}
      format.json { render :json => { :response => :success } }
    end
  end

  def unmanage
    current_user.unmanage_artist params[:id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:id])}
      format.json { render :json => { :response => :success } }
    end
  end

  def unfollow
    current_user.unfollow_artist params[:id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:id])}
      format.json { render :json => { :response => :success } }
    end
  end

  def follow
    current_user.follow_artist params[:id]
    current_user.unsuggest_artist params[:id]
    @artist = Artist.find(current_user.suggested[5].id) rescue nil
    @artist ||= Artist.find(current_user.suggested.last.id) rescue nil
    @tracked_artist = Artist.find(params[:id])
    respond_to do |format|
      format.html { redirect_to artist_path(params[:id])}
      format.json { render("artists/show.json") }
      format.js { render("artists/show.js") }
    end
  end

  def unsuggest
    current_user.unsuggest_artist params[:id]
    redir :id
  end

  def suggest
    current_user.suggest_artist params[:id]
    redir :id
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

end
