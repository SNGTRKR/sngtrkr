class DropSessionsAndShortenedUrlsTable < ActiveRecord::Migration
  def change
    drop_table :sessions
    drop_table :shortened_urls
  end
end
