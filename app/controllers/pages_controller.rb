class PagesController < ApplicationController
  def home
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
    render :layout => 'splash'
  end 
end
