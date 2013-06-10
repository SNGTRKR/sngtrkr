module ApplicationHelper

  def follow_button artist
    if user_signed_in?
      if current_user.following? artist.id
        return link_to(artist_unfollow_path(artist), :method => :post, :class => "remove-trkr btn track active", :remote => true, :'data-id' => artist.id) do
          'Tracked'
        end.html_safe
      else
        return link_to(artist_follows_path(artist), :format => :html, :method => :post,
                       :class => "add-trkr btn track", :remote => true, :'data-id' => artist.id) do
          'Track'
        end.html_safe
      end
    else
      return '<a data-target="#user_signup" data-toggle="modal"> <div class="btn track">Track</div> </a>'.html_safe
    end
  end

  def follow_button_small artist
    if user_signed_in?
      if current_user.following? artist.id
        return link_to(artist_unfollow_path(artist), :method => :post, :class => "remove-trkr-small btn btn-small active follow-#{artist.id}", :remote => true, :'data-id' => artist.id) do
          'Tracked'
        end.html_safe
      else
        return link_to(artist_follows_path(artist), :format => :html, :method => :post,
                       :class => "add-trkr-small btn btn-small follow-#{artist.id}", :remote => true, :'data-id' => artist.id) do
          'Track'
        end.html_safe
      end
    else
      return '<a data-target="#user_signup" data-toggle="modal"> <div class="btn btn-small">Track</div> </a>'.html_safe
    end
  end

  def follow_button_carousel artist
    return link_to(artist_follows_path(artist), :format => :html, :method => :post,
                   :class => "add-trkr-carousel btn btn-small follow-#{artist.id}", :remote => true, :'data-id' => artist.id) do
      'Track'
    end.html_safe
  end
  # allows devise forms to be displayed outside the devise controller
  def resource_name
    :user
  end

  # popover helpers
  def artist_popover artist_obj
    render :partial => 'shared/artist_popover', :locals => { :apop => artist_obj }
  end

  def buy_popover buy_obj
    render :partial => 'shared/buy_popover', :locals => { :bpop => buy_obj }
  end

  def release_popover release_obj, artist_obj
    render :partial => 'shared/release_popover', :locals => { :rpop => release_obj, :apop => artist_obj }
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end