class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fbid, :first_name, :last_name, 
    :last_sign_in_at, :email_frequency, :deleted_at, :leave_reason, :confirmed_at

  validates :fbid, :uniqueness => true, :allow_blank => true
  validates :email, :presence => true, :uniqueness => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  has_many :follow, :dependent => :destroy
  has_many :suggest, :dependent => :destroy
  has_many :feedbacks
  has_and_belongs_to_many :roles

  has_many :following, :through => :follow, :source => :artist
  has_many :suggested_all, :through => :suggest, :source => :artist
  has_many :notification, :dependent => :delete_all
  has_many :release_notifications, :through => :notification, :source => :release
    
  before_save :default_values
  def default_values
    self.email_frequency ||= 1
  end

  def self.ordered
    order('first_name, last_name')
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info

    if user = self.find_by_fbid(data.id)
      user
    else # Create a user with a stub password.
      user = self.new(:email => data.email, :password => Devise.friendly_token[0,20], :fbid => data.id, :first_name => data.first_name, :last_name => data.last_name)
      user.confirm! 
      user.roles << Role.where(:name => 'User').first

      user.save!
    end

    if user.sign_in_count < 2
      ArtistJob.perform_async(access_token.credentials.token, user.id)
    end
    user

  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def soft_delete
    # assuming you have deleted_at column added already
    update_attribute(:deleted_at, Time.current)
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def friends_with? user, friends
    if friends.include? user.fbid
    true
    else
    false
    end
  end

  def manager?
    if managing.count > 0
    true
    else
    false
    end
  end

  def manage_artist artist_id
    t = manage.create(:artist_id => artist_id)
    t.save
    return t.id
  end

  def unmanage_artist artist_id
    manage.delete(manage.where(:user_id => self.id, :artist_id => artist_id))
  end

  def follow_artist artist_id
    t = follow.create(:artist_id => artist_id)
    return t.id
  end

  def unfollow_artist artist_id
    follow.delete(follow.where(:user_id => self.id, :artist_id => artist_id))
  end

  def suggest_artist artist_id
    t = suggest.create(:artist_id => artist_id)
    return t.id
  end

  def unsuggest_artist(artist_id)
    suggest.where(:artist_id => artist_id).each do |f|
      f.ignore = true
      f.save
    end
  end

  def following?(artist_id)
    if !Follow.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end

  def managing?(artist_id)
    if !Manage.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end

  def suggested
    suggested_all.where("suggests.ignore = ?",false)
  end

  def suggested?(artist_id)
    if !Suggest.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end
  
  def recent_activity(opts={:limit => 20})
    recent_follows = self.follow.includes(:artist,:user).order('updated_at DESC').limit(opts[:limit])
    recent_follows.collect! { |follow| {
        :action => 'follow',
        :follow => follow,
        :user => follow.user,
        :artist => follow.artist,
        :time => follow.created_at
      } 
    }

    combined = recent_follows.sort_by!{|action| action[:time]}.reverse
    return combined
  end

  # This works but is a very SQL heavy solution
  def self.recent_activities users
    activities = []
    if !users 
      return []
    end
    users.each do |user|
      u = User.find(user)
      activities += u.recent_activity
    end
    activities.sort_by!{|action| action[:time] }.reverse!
    
    return activities[0,10]
  end

  def self.email_frequencies
    [
      ['Daily',1],
      ['Weekly',2],
      ['Fortnightly',3],
      ['Monthly',4],
      ['Never',5],
    ]
  end

end
