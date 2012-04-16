class Timeline 
  # Not tied to instance as there is no paging
  def self.artist id
    a = Artist.find(:all, id)
    if(!a.empty?) 
      a.releases
    else
      []
    end
  end
  
  # Tied to instance to allow paging
  def self.user id
    artists = User.find(id).followed_artists

    # Gets you all the releases but not sorted in chronological order
    releases = artists.each do |artist|
      artist.releases
    end
  end
end