class FollowsController < ApplicationController

  load_and_authorize_resource

  def index
    redirect_to artist_path(:id => params[:artist_id])
  end

  def create
    @artist = Artist.find(params[:artist_id])
    current_user.followed_artists << @artist

    @recommended = current_user.suggested_artists.first(18)
    @artist = current_user.suggested_artists.where("artists.id NOT IN (?)", @recommended).first
    @recommended << @artist
    respond_to do |format|
      format.html { redirect_to artist_path(:id => params[:artist_id]) }
      format.js { render :partial => 'follows/follow', :format => [:js] }
      format.json { render :json => { :artist => @artist } }
    end

  end

  def destroy
    @artist_id = params[:artist_id]
    @artist = Artist.find(params[:artist_id])
    current_user.followed_artists.delete(@artist)
    respond_to do |format|
      format.js { render :partial => 'follows/unfollow', :format => [:js] }
      format.html { redirect_to artist_path(:id => params[:artist_id]) }
      format.json { render :json => {:response => :success} }
    end
  end


  def batch_destroy
    params[:artist_ids].each do |id|
      current_user.followed_artists.delete(Artist.find(id))
    end
    respond_to do |format|
      format.html { redirect_to current_user }
    end
  end

end
