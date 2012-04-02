class PagesController < ApplicationController
  def home
    require 'koala'
    @graph = Koala::Facebook::API.new 
    render :layout => 'home'
  end
end
