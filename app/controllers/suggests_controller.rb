class SuggestsController < ApplicationController

  def create
    @suggest = current_user.suggest_artist params[:artist_id]
    respond_to do |format|
      format.html { redirect_to artist_path(params[:artist_id])}
      format.json { render :json =>{ :response => :success } }
    end

  end
  
  def destroy
    @artist = current_user.unsuggest_artist params[:artist_id]
    respond_to do |format|
      format.html { redirect_to artist_path(@artist) }
      format.js { render :nothing => true }
      format.json { render :json => { :response => :success } }
    end
  end

end
