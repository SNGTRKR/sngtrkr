class PagesController < ApplicationController

  skip_before_filter :authenticate_user!
  caches_action :home, :layout => false
  caches_action :about, :layout => false
  caches_action :privacy, :layout => false
  caches_action :terms, :layout => false

  def home    
    if(user_signed_in?)
      flash.keep
      return redirect_to '/tl'
    end
    @releases = Rails.cache.fetch("homepage_releases", :expires_in => 24.hours) do
      Release.all(:limit => 66)
    end
  end

  def about  
    
  end
  
  def privacy
  
  end
  
  def terms
  
  end
end
