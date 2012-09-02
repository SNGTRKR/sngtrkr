namespace :paperclip do

  task :reprocess_images => :environment do

    Artist.find_each do |a|
      a.image.reprocess! rescue a.destroy
      puts "Artist #{a.id} processed"
    end

    Release.find_each do |r|
      r.image.reprocess! rescue r.destroy
      puts "Release #{r.id} processed"
    end

  end

end