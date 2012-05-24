class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json

  before_filter :authenticate_user!, :except => [:show]
  def index
    @artists = Artist.search(params[:search])
    if params[:search].blank?
      if Rails.env.production?
        flash.now[:message] = "You must search for an artist"
      else
        @artists = Artist.order(:name).page(params[:page])
      end
    elsif(params[:search].length < 2)
      flash.now[:message] = "Please enter at least 2 characters into the search box"
      @artists = [];
    elsif @artists.empty?
      respond_to do |format|
        format.html { redirect_to no_results_artists_path(:search => params[:search])}# index.html.erb
        format.json { render :json => ActiveSupport::JSON.encode(["failure"]) }
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => ["success", @artists[0..5]] }
      end
    end
  end

  def no_results
    @search = params[:search]
    @user = current_user
    @artists = current_user.suggested
    @artists |= []
    respond_to do |format|
      format.html
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])
    @user = current_user
    @timeline = Timeline.artist(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
    render :layout => false
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, :notice => 'Artist was successfully created.' }
        format.json { render :json => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.json
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to @artist, :notice => 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end
end
