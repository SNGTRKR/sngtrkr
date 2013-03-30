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
			return '<a href="#"> <div class="btn track">Track</div> </a>'.html_safe
		end 
	end

end