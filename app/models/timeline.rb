class Timeline
  def self.artist id
    a = Artist.find(id)
    if (a != nil)
      a.real_releases.order("date DESC")
    else
      []
    end
  end

  def self.user id, page = 0
    offset = page.to_i * 20
    releases = Release.find_by_sql("SELECT releases.* FROM follows JOIN artists ON artists.id = follows.artist_id
      JOIN releases on artists.id = releases.artist_id WHERE follows.user_id = #{id}
      ORDER BY releases.date DESC LIMIT #{offset} , 20")
    ActiveRecord::Associations::Preloader.new(releases, [:artist]).run
    releases
  end

end