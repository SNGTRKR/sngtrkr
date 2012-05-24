class ReleasesController < ApplicationController
  # GET /releases
  # GET /releases.json
  def index
    @artist = Artist.find(params[:artist_id])
    @releases = Release.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.json
  def show
    @artist = Artist.find(params[:artist_id])
    @release = Release.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
  end

  # GET /releases/new
  # GET /releases/new.json
  def new
    @artist = Artist.find(params[:artist_id])
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @artist = Artist.find(params[:artist_id])
    @release = Release.find(params[:id])
  end

  # POST /releases
  # POST /releases.json
  def create
    @artist = Artist.find(params[:artist_id])
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to @release, :notice => 'Release was successfully created.' }
        format.json { render :json => @release, :status => :created, :location => @release }
      else
        format.html { render :action => "new" }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.json
  def update
    @artist = Artist.find(params[:artist_id])
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to @release, :notice => 'Release was successfully updated.' }
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
  
  # Assists the user in filling out the form by fetching data for them.
  def help
    
  end
  
end
