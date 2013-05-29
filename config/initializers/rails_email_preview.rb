require 'rails_email_preview'
RailsEmailPreview.setup do |config|
  config.preview_classes = [UserMailer::Preview]
end

# If you want to render it within the application layout, uncomment the following lines:
# Rails.application.config.to_prepare do
#   RailsEmailPreview::ApplicationController.layout "application"
# end
# Note that if you do use it with your main_app layout, all the main_app URLs must be generated explicitly
# E.g. you would need to change links like login_url to main_app.login_url