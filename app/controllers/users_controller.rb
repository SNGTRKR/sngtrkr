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
    @user = User.find(1)
    respond_to do |format|
      format.html # show.html.erb
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
    redir :artist_id
  end

  def unmanage
    @user.unmanage params[:artist_id]
    redir :artist_id
  end

  def unfollow
    @user.unfollow params[:artist_id]
    redir :artist_id
  end

  def follow
    @user.follow params[:artist_id]
    redir :artist_id
  end

  def unsuggest
    @user.unsuggest params[:artist_id]
    redir :artist_id
  end

  def suggest
    @user.suggest params[:artist_id]
    redir :artist_id
  end

  def import_artists
    @response = Scraper.importFbLikes  params[:access_token]
  end

end
