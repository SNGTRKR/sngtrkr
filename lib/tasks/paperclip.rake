namespace :paperclip do

  task :reprocess_images => :environment do

    Release.order('updated_at ASC').find_each do |r|
      r.image.reprocess! rescue r.destroy
      r.touch
      r.save
      puts "Release #{r.id} processed"
    end

    Artist.order('updated_at ASC').find_each do |a|
      a.image.reprocess! rescue a.destroy
      a.touch
      a.save
      puts "Artist #{a.id} processed"
    end

  end

end