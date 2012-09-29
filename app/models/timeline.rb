class Timeline
  def self.artist id
    a = Artist.find(id)
    if(a != nil)
    a.real_releases.order("date DESC")
    else
    []
    end
  end

  def self.new id
    @@artists = User.find(id).following.collect(&:id)
    self
  end

  def self.user page = 0
    Release.where(:ignore => false).includes(:artist).order("date DESC").where(" artist_id in (?)",@@artists).page(page).per(20)
  end

end