class PagesController < ApplicationController

  skip_before_filter :authenticate_user!, :except => [:intro, :admin_overview]

  def home

  end

  def help 
    render :layout => 'no_sidebar'
  end
  
  def about
  
  end
  
  def privacy
  
  end
  
  def terms
  
  end
  
  def intro 
    render :layout => 'no_sidebar'
  end
  
  def splash
    if(user_signed_in?)
      flash.keep
      return redirect_to '/timeline'
    end
    render :layout => 'splash'
  end 

  def admin_overview
    unless current_user.roles[0].name == "Admin"
      return redirect_to :root
    end

    @users_by_day = User.group('date(created_at)').limit(30).order('created_at DESC').count
    @follows_by_day = Follow.group('date(created_at)').limit(30).order('created_at DESC').count
    @suggests_by_day = Suggest.group('date(created_at)').limit(30).order('created_at DESC').count
    @artists_by_day = Artist.group('date(created_at)').limit(30).order('created_at DESC').count
    @stats_by_day = @users_by_day.collect {|u,i| 
      {
        :date => u, 
        :users => i, 
        :follows => @follows_by_day[u],
        :suggests => @suggests_by_day[u],
        :artists => @artists_by_day[u],
      }
    }

    @popular_artists = Artist.find(:all, :select => 'artists.*, count(follows.id) as follow_count',
             :joins => 'left outer join follows on follows.artist_id = artists.id',
             :group => 'artists.id',
             :order => 'follow_count DESC'
            )

    @prolific_artists = User.find(:all, :select => 'users.*, count(follows.id) as follow_count',
             :joins => 'left outer join follows on follows.user_id = users.id',
             :group => 'users.id',
             :order => 'follow_count DESC'
            )

    render :layout => 'no_sidebar'
  end

end
