module ApplicationHelper

	def follow_button artist
		if user_signed_in? 
			if current_user.following? artist.id 
				return link_to(artist_unfollow_path(artist), :method => :post, :class => "remove-trkr", :remote => true, :'data-id' => artist.id) do 
					'<div class="btn track">Tracked</div>'
				end.html_safe
			else 
				return link_to(artist_follows_path(artist), :format => :html, :method => :post,
				:class => "add-trkr", :remote => true, :'data-id' => artist.id) do 
					'<div class="btn track">Track</div>'
				end.html_safe 
			end 
		else
			return '<a href="#"> <div class="btn track">Track</div> </a>'.html_safe
		end 
	end

end