class ReleasesController < ApplicationController

  skip_authorization_check
  load_and_authorize_resource

  before_filter :managed_artists_only, :only => [:edit, :update, :create, :destroy, :new]
  skip_before_filter :authenticate_user!, :only => [:show]
  cache_sweeper :release_sweeper

  # GET /releases/1
  # GET /releases/1.json
  def show
    @artist = Artist.find(params[:artist_id])
    @release = @artist.releases.find(params[:id])
    @release_count = @artist.count_release
    @releases = @artist.related_releases
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
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
