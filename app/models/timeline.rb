class Timeline 
  @@pagesize = 10

  def self.artist id
    a = Artist.find(id)
    if(a != nil) 
      a.releases
    else
      []
    end
  end
  
  def self.user_init id
    artists = User.find(id).followed_artists

    # Gets you all the releases but not sorted in chronological order
    # TODO Sort in chronological order
    # FIXME This is a bad implementation, we should only search for the page needed
    # in SQL, rather than getting all pages and only showing one.
    @@releases = artists.each do |artist|
      artist.releases
    end
    self
  end
  
  def page p
    @@releases[@@pagesize*(p-1)..@@pagesize*(p)]
  end
  
end