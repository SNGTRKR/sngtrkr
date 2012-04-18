class PagesController < ApplicationController
  def home
    require 'koala'
    if Rails.env.production?
      @fb_app_id = '344989472205984'
    else
      @fb_app_id = '294743537267038'
    end
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
