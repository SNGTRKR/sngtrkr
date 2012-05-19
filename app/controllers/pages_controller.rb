class PagesController < ApplicationController
  def home
    if(user_signed_in?)
      return redirect_to '/home'
    end
    require 'koala'
    @graph = Koala::Facebook::API.new
    render :layout => 'home'
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
      return redirect_to '/home'
    end
    render :layout => 'splash'
  end 
end
