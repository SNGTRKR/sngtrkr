class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  before_filter :cache_it
  caches_page :except => [:home]

  def home
    if(user_signed_in?)
      flash.keep
      return redirect_to '/tl'
    end
  end

  
  def about
  
  end
  
  def privacy
  
  end
  
  def terms
  
  end
end
