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
    @manage = @user.managing.find(params[:id])
    @manage.destroy
    redirect_to edit_user_path(@user)
  end
  

end
