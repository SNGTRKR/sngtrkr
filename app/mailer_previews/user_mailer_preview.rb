class UserMailerPreview
  def welcome_email
    r = Role.create(:name => 'Admin')
    user = User.new(:id => '29', 
                    :first_name => 'Billy', 
                    :last_name => 'Dallimore', 
                    :fbid => "660815460", 
                    :email => "tom.alan.dallimore@googlemail.com", 
                    :password => 'test42343egysfdf', 
                    :last_sign_in_at => Time.now,
                    :email_frequency => 1)
    user.roles = [r]
    user.skip_confirmation!
    user.save
    mail = UserMailer.welcome_email user 
    user.destroy
    mail
  end

  def new_releases_email
    r = Role.create(:name => 'Admin')
    user = User.new(:id => '29', 
                    :first_name => 'Billy', 
                    :last_name => 'Dallimore', 
                    :fbid => "660815460", 
                    :email => "tom.alan.dallimore@googlemail.com", 
                    :password => 'test42343egysfdf', 
                    :last_sign_in_at => Time.now,
                    :email_frequency => 1)
    user.roles = [r]
    user.skip_confirmation!
    user.save
    @artist = Artist.find(142)
    releases = @artist.releases.includes(:artist).where(:ignore => false).limit(4)
    artist_names = "S.P.Y, Netsky, Rihanna, Hatcha"
    mail = UserMailer.new_releases_email(user, artist_names, releases)
    user.destroy
    mail
  end
end
