class MailerController < ApplicationController

  before_filter :authenticate_user!, :only => []

  def welcome
    @user = User.last
    render :file => 'user_mailer/welcome_email.html.erb', :layout => false
  end
  
  def beta
    @user = BetaUser.last
    render :file => 'user_mailer/beta_email.html.erb', :layout => false  
  end
  
  def daily_release
    @user = User.last
    @releases = Release.all[1,3]
    @date = Date.today
    @date_adjective = 'weekly'
    render :file => 'user_mailer/new_releases.html.erb', :layout => false  
  end

end