class PagesController < ApplicationController

  skip_before_filter :authenticate_user!, :except => [:intro]

  before_filter :cache_it
  caches_page :except => [:splash,:home]

  def home
    if(user_signed_in?)
      flash.keep
      return redirect_to '/tl'
    end
    render :layout => 'no_sidebar'
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
      return redirect_to '/tl'
    end
    render :layout => 'splash'
  end 

end
