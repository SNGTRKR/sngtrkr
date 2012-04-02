class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :follow
  has_many :suggest
  has_many :manage
  has_many :super_manage

  has_many :followed_artists, :through => :follow, :source => :artist
  has_many :managed_artists, :through => :manage, :source => :artist
  has_many :suggested_artists, :through => :suggest, :source => :artist

  has_many :labels, :through => :super_manage
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
    t = Suggest. new(:user_id => self.id, :artist_id => artist_id)
    t.save
    return t.id
  end

  def unsuggest(artist_id)
    Suggest.find(:all, :conditions => ["user_id = '#{self.id}' AND artist_id = '#{artist_id}'"]).each do |f|
      f.destroy
    end
  end

  def following?(artist_id)
    if Follow.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end

  def managing?(artist_id)
    if Manage.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end

  def suggested?(artist_id)
    if Suggest.search(self.id, artist_id).count > 0
    return true
    else
    return false
    end
  end
  
  def import_artists(json_response)
    ret = JSON.parse json_response.read
    return ret
  end

end
