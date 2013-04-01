#!/bin/bash
# Starts mysql, solr, and then the rails server
mysql.server start
bundle exec rake sunspot:solr:start
rails s