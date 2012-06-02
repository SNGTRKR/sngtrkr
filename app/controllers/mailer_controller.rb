class MailerController < ApplicationController

  before_filter :authenticate_user!, :only => []

  def welcome()
    @user = User.last
    render :file => 'user_mailer/welcome_email.html.erb', :layout => false
  end
  
  def beta
    @user = BetaUser.last
    render :file => 'user_mailer/beta_email.html.erb', :layout => false  
  end

end