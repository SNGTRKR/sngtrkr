class UserSweeper < ActionController::Caching::Sweeper
  observe User

  # If our sweeper detects that a User was updated call this
  def after_update(user)
    expire_cache_for(user)
  end

  # If our sweeper detects that a User was deleted call this
  def after_destroy(user)
    expire_cache_for(user)
  end

  private
  def expire_cache_for(user)
    # Expire a fragment
    Rails.cache.delete("users/user-#{user.id}")
  end
end