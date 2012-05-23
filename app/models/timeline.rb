class Timeline
  def self.artist id
    a = Artist.find(id)
    if(a != nil)
    a.releases
    else
    []
    end
  end

  def self.new id
    @@artists = User.find(id).following.collect(&:id)
    self
  end

  def self.user
    Release.joins(:artist).order("date DESC").where("artist_id in (?)",@@artists)
  end

end