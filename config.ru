# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'
#run SNGTRKR::Application
run Rack::URLMap.new \
  "/"       => SNGTRKR::Application,
  "/resque" => Resque::Server.new
