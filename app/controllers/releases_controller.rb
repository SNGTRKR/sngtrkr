class ReleasesController < ApplicationController
  # GET /releases
  # GET /releases.json

  skip_authorization_check
  load_and_authorize_resource
  
  before_filter :managed_artists_only, :only => [:edit, :update, :create, :destroy, :new]
  skip_before_filter :authenticate_user!, :only => [:show]

  # GET /releases/1
  # GET /releases/1.json
  def show
    @artist = Artist.find(params[:artist_id])
    @release = @artist.releases.find(params[:id])
    @releases = @artist.real_releases.all(:order => 'date DESC', :limit => 15)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @artist = Artist.find(params[:artist_id])
    @release = @artist.releases.find(params[:id])
  end

  # POST /releases
  # POST /releases.json
  def create
    @artist = Artist.find(params[:artist_id])
    @release = @artist.releases.build(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to [@artist, @release], :notice => 'Release was successfully created.' }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.json
  def update
    @artist = Artist.find(params[:artist_id])
    @release = Release.find(params[:id])
    if params[:release][:delete_image] == "true"
      @release.image.clear
      params[:release].delete(:delete_image)
    end

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to [@artist, @release], :notice => 'Release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.json
  def destroy
    @artist = Artist.find(params[:artist_id])
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to releases_url }
      format.json { head :no_content }
    end
  end
  
end
