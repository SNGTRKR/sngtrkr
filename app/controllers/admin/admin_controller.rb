class Admin::AdminController < ApplicationController

  before_filter :auth_admin

  def auth_admin
    authorize! :access, :administration
  end

  def email
  end

  def overview
    unless cached_current_user.roles[0].name == "Admin"
      return redirect_to :root
    end

    row_length = 15
    @users_by_day = User.group('date_format(created_at,"%d-%m-%y")').limit(row_length).order('created_at DESC').count
    @follows_by_day = Follow.group('date_format(created_at,"%d-%m-%y")').limit(row_length).order('created_at DESC').count
    @suggests_by_day = Suggest.group('date_format(created_at,"%d-%m-%y")').limit(row_length).order('created_at DESC').count
    @artists_by_day = Artist.group('date_format(created_at,"%d-%m-%y")').limit(row_length).order('created_at DESC').count
    @emails_by_day = Notification.group('date_format(sent_at,"%d-%m-%y")').limit(row_length).order('sent_at DESC').count

    @stats_by_day =  []
    for d in 0 .. row_length-1
      d_s = (Date.today - d).strftime("%d-%m-%y")
      @stats_by_day << {
        :date => Date.today - d, 
        :users => @users_by_day[d_s], 
        :follows => @follows_by_day[d_s],
        :suggests => @suggests_by_day[d_s],
        :artists => @artists_by_day[d_s],
        :emails => @emails_by_day[d_s],
      }
    @stats_by_day.reverse
    end

    @popular_artists = Artist.find(:all, :select => 'artists.*, count(follows.id) as follow_count',
             :joins => 'left outer join follows on follows.artist_id = artists.id',
             :group => 'artists.id',
             :order => 'follow_count DESC',
             :limit => row_length
            )

    @prolific_artists = User.find(:all, :select => 'users.*, count(follows.id) as follow_count',
             :joins => 'left outer join follows on follows.user_id = users.id',
             :group => 'users.id',
             :order => 'follow_count DESC',
             :limit => row_length
            )
    @reports = Report.all

  end

end