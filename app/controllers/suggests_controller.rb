class SuggestsController < ApplicationController

  load_and_authorize_resource

  def create
    @suggest = current_user.suggest_artist params[:artist_id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:artist_id]) }
      format.json { render :json => {:response => :success} }
    end

  end

  def destroy
    current_user.unsuggest_artist params[:artist_id]
    @artist = current_user.suggested[5] rescue nil
    respond_to do |format|
      format.html { render "artists/ajax_suggestion", :layout => false }
      if @artist
        format.json { render :json => {:artist => @artist,
                                       :image_url => @artist.image.url(:sidebar_suggest), :followers => @artist.followed_users.count} }
      else
        format.json { render :nothing => true }
      end
    end
  end

end
