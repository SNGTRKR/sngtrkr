require 'rubygems'
require 'sitemap_generator'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.sngtrkr.com"
SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add about_path, :lastmod => Time.now, :changefreq => 'monthly', :priority => 1
  add privacy_path, :lastmod => Time.now, :changefreq => 'monthly', :priority => 1
  add terms_path, :lastmod => Time.now, :changefreq => 'monthly', :priority => 1

  Artist.find_each do |artist|
    add artist_path(artist), :lastmod => artist.updated_at
    @all_releases = artist.real_releases
    @all_releases.find_each do |release|
      add artist_release_path(artist, release), :lastmod => release.updated_at
    end
  end

end
SitemapGenerator::Sitemap.ping_search_engines
