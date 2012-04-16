class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases
  belongs_to :label

  has_many :follow
  has_many :suggest
  has_many :manage

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user
  has_many :manager_users, :through => :manage, :source => :user

  after_initialize :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
  end

  def self.search(search)
    if search
      find(:all, :conditions => ["name LIKE %#{search}%"])
    else
      find(:all)
    end
  end

  def self.managed?(artist_id)
    if(Manage.find(:all, :conditions => ["artist_id = #{artist_id}"]).empty?)
    return false
    else
    return true
    end
  end

end
