class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json

  before_filter :authenticate_user!, :except => [:show, :search, :index]
  before_filter :managed_artists_only, :only => [:edit, :update]
  load_and_authorize_resource :except => [:search]
  cache_sweeper :artist_sweeper

  # GET /artists/1
  # GET /artists/1.json
  def show
    @a_param = params[:id]
    @current_artist = Artist.find(@a_param)
    @artist = Rails.cache.fetch "artist/artists-#{@current_artist.id}", expires_in: 2.hours do
      Artist.includes(:releases).find(@a_param)
    end
    @user = current_user
    # @timeline = Rails.cache.fetch "artist_timeline/#{@current_artist.id}-#{@current_artist.updated_at}", expires_in: 2.hours do
    @timeline = Timeline.artist(@a_param).page(params[:page])
    # end
    @release_count = @artist.count_release
    # @events = @artist.songkick_events
    respond_to do |format|
      format.js { render :partial => "timeline/artist_timeline", :format => [:js] } 
      format.html # show.html.erb
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
    @@sevendigital_apikey = "7dufgm34849u"
    require 'open-uri'
    if @artist.sdid?
      @sd_info = Hash.from_xml open("http://api.7digital.com/1.2/artist/details?artistid=#{CGI.escape(@artist.sdid)}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")
    end
    if @artist.itunes_id?
      @itunes_info = ActiveSupport::JSON.decode(open("http://itunes.apple.com/lookup?id=#{@artist.itunes_id}&country=GB"))
    end
    respond_to do |format|
      format.html
    end
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
        format.js
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
