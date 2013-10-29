module ApplicationHelper

  def follow_button artist, btn_type, tracking_name
    # Setup button type
    if btn_type == "normal"
      btn_class = "btn track"
      btn_trkr = ""

    elsif btn_type == "small"
      btn_class = "btn btn-small"
      btn_trkr = "-small"
    elsif btn_type == "tile"
      btn_class = "act track_artist"
      btn_trkr = "-tile"
    end

    if user_signed_in?
      if current_user.following? artist.id
        return link_to(artist_unfollow_path(artist, :format => [:js]), :class => "remove-trkr#{btn_trkr} #{btn_class} active", :remote => true, :'data-id' => artist.id, :'data-tracking' => 'true', :'data-tracking-category' => :'unfollow', :'data-tracking-name' => tracking_name) do
          'Tracked'
        end
      else
        return link_to(artist_follow_path(artist, :format => [:js]), :class => "add-trkr#{btn_trkr} #{btn_class}", :remote => true, :'data-id' => artist.id, :'data-tracking' => 'true', :'data-tracking-category' => 'follow', :'data-tracking-name' => tracking_name)  do
          'Track'
        end.html_safe
      end
    else
      return "<a data-target='#user_signup' data-toggle='modal' class='#{btn_class}' data-tracking='true' data-tracking-category='follow' data-tracking-name='#{tracking_name}'>Track</a>".html_safe
    end
  end

  def follow_button_carousel artist
    return link_to artist_follow_path(artist, :format => [:json]), :class => "add-trkr-carousel btn btn-small follow-#{artist.id}", :remote => true, :'data-id' => artist.id, :'data-tracking' => 'true', :'data-tracking-category' => 'follow', :'data-tracking-name' => 'carousel-suggest' do
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

  def active_page page
    "active" if current_page?(page)
  end

  def signed_in_search(current_user)
    if current_user
      "navbar-search pull-left signed_in_search"
    else
      "navbar-search pull-left"
    end
  end

end