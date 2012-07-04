class ManagesController < ApplicationController
  def create
    @manage = Manage.new(params[:manage])
    @manage.user_id = current_user.id
    @manage.save
    respond_to do |format|
      format.html { redirect_to edit_artist_path(@manage.artist) }
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @manage = @user.manage.find(params[:id])
    @manage.destroy
    redirect_to edit_user_path(@user), :notice => '<p>You are no longer managing any artists. Should you wish to manage a different artist, or resume managing the same artist, just pay a visit to your profile settings page.</p>'
  end
  
  def scrape_confirm
    @artist = Artist.find(params[:artist_id])
    
    respond_to do
      format.html
    end
  end

end
