class TimelineController < ApplicationController
  def index
    user_timeline = Timeline.new current_user.id
    @timeline = user_timeline.user params[:page]
    respond_to  do |format|
      format.js { render :partial => "timeline/user_timeline.js" }
    end
  end
end
