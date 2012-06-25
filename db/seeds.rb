# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
r = Role.create(:name => 'Admin')
u = User.new(:first_name => 'Billy', :last_name => 'Dallimore', :fbid => "660815460", :email => "tom.alan.dallimore@googlemail.com",:password => 'test42343egysfdf', :last_sign_in_at => Time.now, 
  :email_frequency => 1)
u.roles = [r]
u.save

u = User.new(:first_name => 'Matt', :last_name => 'Bessey', :fbid => "757635703", :email => "bessey@gmail.com",:password => 'test42343egy20df', :last_sign_in_at => Time.now)
u.roles = [r]
u.save
User.create!(:first_name => 'Barry', :last_name => 'Smith', :fbid => "123456789", :email => "test@example.com",:password => 'test42343egy76df', :last_sign_in_at => Time.now, 
  :email_frequency => 1)

Artist.create!(:name =>"JellyFishBoy", :fbid => "204842319549165", :genre => "Dubstep", :hometown => "Bristol", :booking_email => "billy@jellyfishboy.co.uk")
Artist.create!(:name =>"False Economy", :fbid => "193078984080645", :genre => "Dubstep", :hometown => "Bristol", :booking_email => "bessey@gmail.com")

User.find(1).following.build(:id => Artist.find(1).id).save
User.find(2).following.build(:id => Artist.find(1).id).save

r1 = Release.create!(:name => "Test", :date => Date.today, :artist_id => Artist.find(1))
r2 = Release.create!(:name => "Second Test", :date => Date.today, :artist_id => Artist.find(2))

User.find(2).release_notifications << r1
User.find(2).release_notifications << r2