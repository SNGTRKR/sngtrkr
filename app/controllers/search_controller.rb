class SearchController < ApplicationController

  skip_before_filter :authenticate_user!

  def omni

    a_page = params[:a_page]
    r_page = params[:r_page]
    per_page = 20

    @search = params[:query]

    @artists_solr = Artist.search do
      fulltext params[:query]
      paginate :page => a_page, :per_page => per_page
      with :ignore, false
    end

    @artists = @artists_solr.results
    @artists_count = @artists_solr.total
    # calculate number of pages for results
    @artists_pages = (@artists_count/20.to_f).ceil
    @artists_json = @artists.map do |a|
      {
          :value => a.name,
          :tokens => a.name,
          :id => a.id,
          :label => a.label_name,
          :image => a.image.small,
          :identifier => "artist_search",
      }
    end

    @releases_solr = Release.search do
      fulltext params[:query]
      paginate :page => r_page, :per_page => per_page
    end

    # Caches artist names in one query
    release_ids = @releases_solr.results.map { |r| r.id }
    @releases_count = @releases_solr.total
    if @releases_count > 0
      @releases = Release.includes(:artist).find(release_ids)
    end
    # calculate number of pages for results
    @releases_pages = (@releases_count/20.to_f).ceil

    @releases_json = @releases.map do |r|
      {
          :value => r.name,
          :tokens => r.artist.name + " - " + r.name,
          :artist_name => r.artist.name,
          :id => r.id,
          :artist_id => r.artist_id,
          :image => r.image.small,
          :identifier => "release_search",
      }
    end

    @json_results = @releases_json + @artists_json

    respond_to do |format|
      format.js { render :partial => "search/omni", :formats => [:js] }
      format.json { render :json => @json_results }
      format.html
    end
  end
end
