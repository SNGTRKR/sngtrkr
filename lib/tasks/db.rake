namespace :db do
  desc "Seed the database with dummy data using Faker, takes one argument dictating whether or not it should overwrite existing records."
  task :fake_seed, [:overwrite] => :environment do |t, args|
  	if Rails.env.production?
  		raise "NOT GOING TO LET YOU DO THIS IN PRODUCTION BRO"
  	end

	  args.with_defaults(:overwrite => false)
  	if !args.overwrite and (Artist.count > 0 or Release.count > 0)
  		puts "Not seeding database as it already has contents and :overwrite=#{args.overwrite}"
  		next
  	end

    matt = User.find_by_email("bessey@gmail.com")
    billy = User.find_by_email("tom.alan.dallimore@googlemail.com")

    Release.destroy_all
  	Artist.destroy_all
  	50.times do |n|
  		artist = FactoryGirl.create(:artist, :with_random_image)
      4.times do
        FactoryGirl.create(:release, :with_random_image, artist: artist)
      end
      # Suggests 1 in 3 artists to the developers, populating their timelines
      if n % 3 == 0
        matt.followed_artists << artist
        billy.followed_artists << artist
      end
  	end

  	puts "Created #{Artist.count} dummy artists, and #{Release.count} dummy releases."

  end

end
