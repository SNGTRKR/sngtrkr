# Load the rails application
require File.expand_path('../application', __FILE__)

$proxy = nil

Date::DATE_FORMATS.merge!(:default => "%d/%m/%y")

if ENV["RAILS_ENV"] == "production"
  FB_APP_ID = '344989472205984'
  FB_APP_SECRET = 'f292de39b6ea01f60ac1c0f6bb2f054f'
else
  FB_APP_ID = '294743537267038'
  FB_APP_SECRET = '1b0a8ec279073577928e87c37c7be342'
end

# Initialize the rails application
SNGTRKR::Application.initialize!

require_dependency 'scraper'
require_dependency 'scraper_2'
