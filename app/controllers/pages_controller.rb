class PagesController < ApplicationController

  def home
    require 'koala'
    @fb_app_id = '344989472205984' # 344989472205984 -sngtrkr # 294743537267038 -local
    @graph = Koala::Facebook::API.new 
    render :layout => 'home'
  end
  def manage 
    
  end
  def recommended
    
  end
  def splash
  render :layout => 'splash'  
  end
end
