class TimelineController < ApplicationController
  def index
    user_timeline = Timeline.new current_user.id
    @timeline = user_timeline.user
    render :partial => "timeline/user_timeline.js"
  end
end
