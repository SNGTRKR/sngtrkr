class PagesController < ApplicationController

  skip_authorization_check
  skip_before_filter :authenticate_user!, :except => [:intro]

  def home
    if(user_signed_in?)
      flash.keep
      return redirect_to '/tl'
    end
    # Used to auto log the user in.
    require 'koala'
    @graph = Koala::Facebook::API.new
    #flash[:success] = "<p>I done a success!</p>"
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
  
  def limbo
    render :layout => 'no_response'
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
  #def beta
  #  render :layout => 'beta'
  #end 
end
