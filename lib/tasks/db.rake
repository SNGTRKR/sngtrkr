namespace :db do
  desc "Seed the database with dummy data using Faker"
  task :fake_seed => :environment do
  	if Rails.env.production?
  		raise "NOT GOING TO LET YOU DO THIS IN PRODUCTION BRO"
  	end
  	Artist.delete_all
  	Release.delete_all
  	100.times do |n|
  		FactoryGirl.create(:artist_with_releases)
  	end

  	puts "Created #{Artist.count} dummy artists, and #{Release.count} dummy releases."
  end

end
