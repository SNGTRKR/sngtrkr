class ManagesController < ApplicationController
  def create
    @manage = Manage.new(params[:manage])
    @manage.user_id = current_user.id

    respond_to do |format|
      if @manage.save
        format.js { redirect_to edit_artist_url(@manage.artist_id) }
      else
        #format.html { render :action => "new" }
        #format.json { render :json => @manage.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @manage = @user.managing.find(params[:id])
    @manage.destroy
    redirect_to edit_user_path(@user)
  end
  

end
