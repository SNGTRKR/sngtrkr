DynamicSitemaps::Sitemap.draw do
  
  # default per_page is 50.000 which is the specified maximum.
   per_page 10

   url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
   
   url about_url, :last_mod => DateTime.now, :change_freq => 'monthly', :priority => 1
   
   url help_url, :last_mod => DateTime.now, :change_freq => 'weekly', :priority => 1
   
   url privacy_url, :last_mod => DateTime.now, :change_freq => 'monthly', :priority => 1
   
   url terms_url, :last_mod => DateTime.now, :change_freq => 'monthly', :priority => 1
   
   
  
   new_page!
  
   Artist.all.each do |artist|
     url artist_url(artist), :last_mod => artist.updated_at, :change_freq => 'weekly', :priority => 1
   end
   
   Release.all.each do |release|
     url release_url(release), :last_mod => artist.updated_at, :change_freq => 'weekly', :priority => 1
   end
 
   new_page!
end