class TimelineController < ApplicationController

  load_and_authorize_resource
  skip_before_filter :authenticate_user!

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
