class Scraper
  include MusicBrainz
  require "Sevendigital"
  include Sevendigital

  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital (Sevendigital) - https://github.com/filip7d/7digital

  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end

  def self.sevenDigitalSearch search
    api_client = Sevendigital::Client.new()
    an_artist = api_client.artist.search(search).first
    a_release = an_artist.releases(:page_size=>10).sort_by{|release| release.year}.last
    return "the latest #{an_artist.name} release is #{a_release.title} from #{a_release.year}” puts “go and buy it at #{a_release.url} !"
  end

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)

    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

end