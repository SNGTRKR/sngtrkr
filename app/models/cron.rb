class Cron
  def self.daily_release
    Artist.where(:ignore => false).each do |artist|
      Resque.enqueue(ReleaseJob, artist.id)
    end
  end
end