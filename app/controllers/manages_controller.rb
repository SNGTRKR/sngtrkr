class ManagesController < ApplicationController
  def create
    @manage = Manage.new(params[:manage])
    @manage.user_id = current_user.id

    respond_to do |format|
      if @manage.save
#        format.html { redirect_to @manage, :notice => 'Label was successfully created.' }
        format.json { render :json => @manage, :status => :created, :location => @manage }
      else
        format.html { render :action => "new" }
        format.json { render :json => @manage.errors, :status => :unprocessable_entity }
      end
    end
  end

end
