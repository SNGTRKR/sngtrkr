require 'actionpack/action_caching'

class PagesController < ApplicationController

  skip_before_filter :authenticate_user!
  caches_action :home, :layout => false
  caches_action :about, :layout => false
  caches_action :privacy, :layout => false
  caches_action :terms, :layout => false

  def home
    if (user_signed_in?)
      flash.keep
      # FIXME: This may be triggering the url shortener loop
      redirect_to '/timeline'
    end
    @releases = Release.includes(:artist).all(:limit => 66)
    # @releases = Rails.cache.fetch("homepage_releases", :expires_in => 24.hours) { Release.includes(:artist).all(:limit => 66) }
  end

  def explore
    @recent_releases = Release.includes(:artist).order("date DESC").page(params[:page])
    @popular_artists = Artist.select("artists.*,count(follows.id) as follow_count").joins(:follows).group("follows.artist_id").having("follow_count > 2").order("follow_count DESC").page(params[:page])
  end

  def explore_release
    @recent_releases = Release.includes(:artist).order("date DESC").page(params[:page])
    respond_to do |format|
      format.js { render :partial => "explore/explore_release", :formats => [:js] }
    end
  end

  def explore_artist
    @popular_artists = Artist.select("artists.*,count(follows.id) as follow_count").joins(:follows).group("follows.artist_id").having("follow_count > 2").order("follow_count DESC").page(params[:page])
    respond_to do |format|
      format.js { render :partial => "explore/explore_artist", :formats => [:js] }
    end
  end

  def about

  end

  def privacy

  end

  def terms

  end
end
