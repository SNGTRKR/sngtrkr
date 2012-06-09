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

  def self.user page = 0
    Release.joins(:artist).where("artist_id in (?)",@@artists).order("date DESC").page(page).per(10)
  end

end