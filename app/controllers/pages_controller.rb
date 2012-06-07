class PagesController < ApplicationController

  def home
    if(user_signed_in?)
      return redirect_to '/timeline'
    end
    require 'koala'
    @graph = Koala::Facebook::API.new
  end

  def manage

  end

  def recommended

  end
  
  def about
  
  end
  
  def privacy
  
  end
  
  def terms
  
  end
  
  def splash
    if(user_signed_in?)
      return redirect_to '/timeline'
    end
    render :layout => 'splash'
  end 
  def beta
    
    render :layout => 'beta'
  end 
end
