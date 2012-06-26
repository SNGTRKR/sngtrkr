class TimelineController < ApplicationController
  def index(page=0)
    user_timeline = Timeline.new current_user.id
    @timeline = user_timeline.user page
    respond_to  do |format|
      format.js { render :partial => "timeline/user_timeline.js" }
    end
  end
end
