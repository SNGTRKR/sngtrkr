class FollowsController < ApplicationController

  load_and_authorize_resource

  def index
    redirect_to artist_path(:id => params[:artist_id])
  end

  def create
    cached_current_user.follow_artist params[:artist_id]
    
    @tracked_artist = Artist.find(params[:artist_id])

    # Generate suggestions based on this
    if @tracked_artist.sdid?
      suggestions = Scraper.similar_artists_7digital(@tracked_artist.sdid)
      if suggestions
        suggestions.each do |suggestion|
          if suggestion.is_a?(Hash) and Artist.where(:sdid => suggestion["id"]).count > 0
            cached_current_user.suggest_artist(Artist.where(:sdid => suggestion["id"]).first.id)
          end
        end
      end
    end


    @artist = cached_current_user.suggested[5] rescue nil
    respond_to do |format|
      format.html { redirect_to artist_path(:id => params[:artist_id]) } #format.html { render "artists/ajax_suggestion", :layout => false }
      if @artist
        format.js { render :partial => 'follows/follow', :format => [:js]}
        format.json { render :json => {:artist => @artist, 
          :image_url => @artist.image.url(:sidebar_suggest), :followers => @artist.followed_users.count} }
      else
        format.json { render :nothing => true }
      end
    end

  end

  def batch_destroy
    params[:artist_ids].each do |id|
      cached_current_user.unfollow_artist id
    end
    respond_to do |format|
      format.html { redirect_to cached_current_user }
    end
  end
  
  def user_destroy
    cached_current_user.unfollow_artist params[:artist_id]
    @artist_id = params[:artist_id]
    respond_to do |format|
      format.js { render :partial => 'follows/unfollow', :format => [:js] }
      format.html { redirect_to artist_path(:id => params[:artist_id]) }
      format.json { render :json => { :response => :success } }
    end
  end

end
