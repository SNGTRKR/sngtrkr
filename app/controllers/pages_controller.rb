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
end
