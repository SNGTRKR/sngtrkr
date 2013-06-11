# Allow usage on Vagrant
BetterErrors::Middleware.allow_ip! "10.0.2.2" if defined? BetterErrors && Rails.env == :development