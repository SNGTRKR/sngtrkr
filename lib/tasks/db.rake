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

    Release.destroy_all
  	Artist.destroy_all
  	100.times do |n|
  		FactoryGirl.create(:artist_with_releases)
  	end

  	puts "Created #{Artist.count} dummy artists, and #{Release.count} dummy releases."
  end

end
