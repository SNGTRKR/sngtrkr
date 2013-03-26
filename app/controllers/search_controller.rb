class SearchController < ApplicationController
	def omni
    @artists = Artist.search do
      fulltext params[:query]
      paginate :page => 1, :per_page => 5
      with :ignore, false
    end

    @artists = @artists.results.map do|a| 
    	{
    		:name => a.name,
    		:id => a.id,
    		:image => a.image, # replace with sized image
    	}
    end

    @releases = Release.search do
      fulltext params[:query]
      paginate :page => 1, :per_page => 5
    end

    @releases = @releases.results.map do |r|
    	{
    		:name => r.name,
    		:artist_name => r.artist.name,
    		:id => r.id,
    		:artist_id => r.artist_id,
    		:image => r.image, # replace with sized image
    	}    	
    end

		render :json => {:artists => @artists, :releases => @releases}
	end
end
