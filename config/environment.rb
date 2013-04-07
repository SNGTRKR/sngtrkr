# Load the rails application
require File.expand_path('../application', __FILE__)

$proxy = nil

Date::DATE_FORMATS.merge!(:default => "%d/%m/%y")

# Initialize the rails application
SNGTRKR::Application.initialize!

if Rails.env.production?
  FB_APP_ID = '344989472205984'
  FB_APP_SECRET = 'f292de39b6ea01f60ac1c0f6bb2f054f'
else
  FB_APP_ID = '294743537267038'
  FB_APP_SECRET = '1b0a8ec279073577928e87c37c7be342'
end

# Specify wether or not in development mode imported artists are reimported on every launch or not
IMPORT_REPLACE = true

require_dependency 'scraper'
require_dependency 'release_scraper'
require_dependency 'artist_scraper'
