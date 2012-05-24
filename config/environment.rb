# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['AMAZON_ACCESS_KEY'] = 'AKIAIEBWHRBGTD5XBYMA'
ENV['AMAZON_SECRET_KEY'] = '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'

ENV['MATT_AMAZON_ACCESS_KEY'] = 'AKIAINYRF3QIYA5YXXYQ'
ENV['MATT_AMAZON_SECRET_KEY'] = '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'

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