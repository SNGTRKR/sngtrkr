# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
r = Role.create(:name => 'Admin')
r2 = Role.create(:name => 'User')

u = User.new(:first_name => 'Billy', :last_name => 'Dallimore', :fbid => "660815460", :email => "tom.alan.dallimore@googlemail.com", :password => 'test42343egysfdf', :last_sign_in_at => Time.now,
             :email_frequency => 1)
u.roles = [r]
u.skip_confirmation!
u.save

u = User.new(:first_name => 'Matt', :last_name => 'Bessey', :fbid => "757635703", :email => "bessey@gmail.com", :password => 'test42343egy20df', :last_sign_in_at => Time.now)
u.roles = [r]
u.skip_confirmation!
u.save
