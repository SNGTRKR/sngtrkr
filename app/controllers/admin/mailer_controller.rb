class Admin::MailerController < ApplicationController

  def welcome()
    @user = User.last
    render :file => 'user_mailer/welcome_email.html.erb', :layout => false
  end
  
  def beta
    @user = BetaUser.last
    render :file => 'user_mailer/beta_email.html.erb', :layout => false  end

  def preview_welcome()
    @user = User.last
    render :file => 'user_mailer/welcome_email.html.erb', :layout => 'mailer'
  end


end