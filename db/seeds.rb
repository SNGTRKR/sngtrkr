# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
r = Role.create(:name => 'Admin')
u = User.new(:first_name => 'Billy', :last_name => 'Dallimore', :fbid => "660815460", :email => "tom.alan.dallimore@googlemail.com",:password => 'test42343egysfdf', :last_sign_in_at => Time.now)
u.roles = [r]
u.save

u = User.new(:first_name => 'Matt', :last_name => 'Bessey', :fbid => "757635703", :email => "bessey@gmail.com",:password => 'test42343egy20df', :last_sign_in_at => Time.now)
u.roles = [r]
u.save
User.create!(:first_name => 'Barry', :last_name => 'Smith', :fbid => "123456789", :email => "test@private.com",:password => 'test42343egy76df', :last_sign_in_at => Time.now)
Artist.create!( :id => '25', :name =>"JellyFishBoy", :fbid => "204842319549165", :genre => "Dubstep", :hometown => "Bristol", :booking_email => "billy@jellyfishboy.co.uk")
