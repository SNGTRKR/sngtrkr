class ArtistSweeper < ActionController::Caching::Sweeper

  def after_update(artist)
    expire_cache_for(artist)
  end

  def after_destroy(artist)
    expire_cache_for(artist)
  end

  def expire_cache_for(artist)
    Rails.cache.delete("artist/artists-#{artist.id}")
  end

end