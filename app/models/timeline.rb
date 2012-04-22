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

  def self.user id
    @@artists = User.find(id).followed_artists.collect(&:id)
    self
  end

  def self.page p
    Release.joins(:artist).order("date DESC").limit(@@pagesize).offset(@@pagesize*(p-1)).find(:all, :conditions => ["artist_id in (?)",@@artists])
  end

end