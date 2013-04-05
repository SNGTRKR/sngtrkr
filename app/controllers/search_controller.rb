class SearchController < ApplicationController

  skip_before_filter :authenticate_user!
  
  def omni

    if request.format == :html
      a_page = params[:a_page]
      r_page = params[:r_page]
      per_page = 20
    elsif request.format == :json
      page = 1
      per_page = 5
    end

    @search = params[:query]

    @artists_solr = Artist.search do
      fulltext params[:query]
      paginate :page => a_page, :per_page => per_page
      with :ignore, false
    end

    @artists = @artists_solr.results
    @artists_count = @artists_solr.total

    @artists_json = @artists.map do|a| 
      {
        :name => a.name,
        :id => a.id,
        :image => a.image, # replace with sized image
      }
    end

    @releases_solr = Release.search do
      fulltext params[:query]
      paginate :page => r_page, :per_page => per_page
    end
    
    # Caches artist names in one query
    release_ids = @releases_solr.results.map{|r| r.id }
    @releases_count = @releases_solr.total
    if @releases_count > 0 
      @releases = Release.includes(:artist).find(release_ids)
    end

    @releases_json = @releases.map do |r|
      {
        :name => r.name,
        :artist_name => r.artist.name,
        :id => r.id,
        :artist_id => r.artist_id,
        :image => r.image, # replace with sized image
      }      
    end

    respond_to do |format|
      format.json { render :json => {:artists => @artists_json, :releases => @releases_json} }
      format.html
    end
  end
end
