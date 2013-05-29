class TimelineController < ApplicationController

  load_and_authorize_resource

  def index
    @timeline = Timeline.user(@user.id, params[:page])
    respond_to do |format|
      format.js { render :partial => "timeline/user_timeline.js" }
    end
  end
end
