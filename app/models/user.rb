class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fbid, :first_name, :last_name

  has_many :follow
  has_many :suggest
  has_many :manage
  has_many :super_manage

  has_many :followed_artists, :through => :follow, :source => :artist
  has_many :managed_artists, :through => :manage, :source => :artist
  has_many :suggested_artists, :through => :suggest, :source => :artist

  has_many :labels, :through => :super_manage
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
    user
    else # Create a user with a stub password.
      user = self.create!(:email => data.email, :password => Devise.friendly_token[0,20], :fbid => data.id, :first_name => data.first_name, :last_name => data.last_name)
    end
    Scraper.importFbLikes(access_token.credentials.token, user.id)
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  def manage(artist_id)
    m = Manage.new(:user_id => self.id, :artist_id => artist_id)
    m.save
    return m.id
  end

  def unmanage(artist_id)
    Manage.find(:all, :conditions => ["user_id = '#{self.id}' AND artist_id = '#{artist_id}'"]).each do |f|
      f.destroy
    end
  end

  def follow(artist_id)
    t = Follow.new(:user_id => self.id, :artist_id => artist_id)
    t.save
    return t.id
  end

  def unfollow artist_id
    Follow.find(:all, :conditions => ["user_id = '#{self.id}' AND artist_id = '#{artist_id}'"]).each do |f|
      f.destroy
    end
  end

  def suggest(artist_id)
    t = Suggest.new(:user_id => self.id, :artist_id => artist_id)
    t.save
    return t.id
  end

  def unsuggest(artist_id)
    Suggest.find(:all, :conditions => ["user_id = '#{self.id}' AND artist_id = '#{artist_id}'"]).each do |f|
      f.ignore = true
      f.save
    end
  end

  def following?(artist_id)
    if Follow.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end

  def following
    Follow.user_follows(self.id)
  end

  def managing?(artist_id)
    if Manage.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end

  def managing
    Manage.user_managing(self.id)
  end

  def suggested?(artist_id)
    if Suggest.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end

  def suggested
    #TODO fix suggested artists.
    self.suggested_artists.find(:all,:conditions => ["suggests.ignore = ?",false])
  end

end
