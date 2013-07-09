class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fbid, :first_name, :last_name,
                  :last_sign_in_at, :email_frequency, :deleted_at, :leave_reason, :confirmed_at, :privacy_policy

  validates :fbid, :uniqueness => true, :allow_blank => true, :allow_nil => true
  validates :email, :presence => {:message => "An email address is required."}, :uniqueness => {:message => "Email address has already been taken."}
  validates :first_name, :presence => {:message => "A first name is required."}
  validates :last_name, :presence => {:message => "A last name is required."}
  validates :privacy_policy, :acceptance => {:message => "Please accept the Privacy policy."}
  validates_format_of :email, :with => /@/
  validates :password, :presence => { :message => "A password is required."}

  has_many :follows, :dependent => :destroy
  has_many :suggests, :dependent => :destroy
  has_many :feedbacks
  has_and_belongs_to_many :roles

  has_many :followed_artists, :through => :follows, :source => :artist
  has_many :suggested_artists, :through => :suggests, :source => :artist
  has_many :notifications, :dependent => :delete_all
  has_many :release_notifications, :through => :notifications, :source => :release do
    def current
      select("`releases`.*, `notifications`.`id` AS `notification_id`")
      .where("`releases`.`date` < ? AND `notifications`.`sent` = ?", Date.today+1, false).limit(20)
    end

    def artist_names
      select('DISTINCT `releases`.`artist_id`')
      .where("`releases`.`date` < ? AND `notifications`.`sent` = ?", Date.today+1, false).limit(3).collect { |r| r.artist.name }.join(', ')
    end
  end

  before_save :default_values

  scope :ordered, order('first_name, last_name')

  def default_values
    self.email_frequency ||= 1
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info

    if user = self.find_by_fbid(data.id)
      user
    else # Create a user with a stub password.
      user = self.new(:email => data.email, :password => Devise.friendly_token[0, 20], :fbid => data.id, :first_name => data.first_name, :last_name => data.last_name)
      user.confirm!
      user.roles << Role.where(:name => 'User').first

      user.save!
    end

    if user.sign_in_count > 1
      first_time = false
    else
      first_time = true
    end

    ArtistJob.perform_async(access_token.credentials.token, user.id, first_time)
    
    return user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end

  def soft_delete(params)
    update_attributes(:deleted_at => Time.current, :leave_reason => params)
  end

  def friends_with? user, friends
    if friends.include? user.fbid
      true
    else
      false
    end
  end

  def following?(artist_id)
    unless @follow_ids
      @follow_ids = Follow.where(:user_id => id).map{|f| f.artist_id }
    end

    return @follow_ids.include? artist_id

  end

  def suggested?(artist_id)
    unless @suggest_ids
      @suggest_ids = Suggest.where(:user_id => id, :ignore => false).map{|f| f.artist_id }
    end

    return @suggest_ids.include? artist_id
  end

  def recent_activity(opts={:limit => 20})
    recent_follows = self.follows.includes(:artist, :user).order('updated_at DESC').limit(opts[:limit])
    recent_follows.collect! { |follow| {
        :action => 'follow',
        :follow => follow,
        :user => follow.user,
        :artist => follow.artist,
        :time => follow.created_at
    }
    }

    combined = recent_follows.sort_by! { |action| action[:time] }.reverse
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
    activities.sort_by! { |action| action[:time] }.reverse!

    return activities[0, 10]
  end

  def self.email_frequencies
    [
        ['Daily', 1],
        ['Weekly', 2],
        ['Fortnightly', 3],
        ['Monthly', 4],
        ['Never', 5],
    ]
  end

  def self.serialize_from_session(key,other)
    single_key = key.is_a?(Array) ? key.first : key
    Rails.cache.fetch("users/user-#{single_key}") { User.includes(:roles,:followed_artists).find(single_key) }
  end

end
