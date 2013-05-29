class ReleaseSweeper < ActionController::Caching::Sweeper
  observe Release

  def after_update(release)
    expire_cache_for(release)
  end

  def after_destroy(release)
    expire_cache_for(release)
  end

  private
  def expire_cache_for(release)
    Rails.cache.delete("releases/release-#{release.id}")
  end

end