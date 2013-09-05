class TimelineController < ApplicationController

  load_and_authorize_resource

  def index
    @timeline = Timeline.user(@user.id, params[:page])
    respond_to do |format|
      format.js { render :partial => "timeline/timeline", :formats => [:js] }
    end
  end

  def populate_user_timeline
    # Clear the user timeline cache before adding more to the timeline
    Rails.cache.delete("timeline/timeline-#{current_user.id}")
  	@artist = Artist.find(params[:timeline_artist])
    @releases = @artist.timeline_releases
    respond_to do |format|
      format.js { render :partial => "timeline/new_releases", :formats => [:js] }
    end
  end
end
