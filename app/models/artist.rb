class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases
  belongs_to :label

  has_attached_file :image, :styles => {
    :large => "220x252#",
    :thumb => "76x76#" }

  has_many :follow
  has_many :suggest
  has_many :manage

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user
  has_many :manager_users, :through => :manage, :source => :user

  before_save :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    true
  end

  def self.search(search)
    if search
      where("name LIKE ?","%#{search}%").page
    else
    self.page.all
    end
  end

  def managed?
    if(Manage.where("artist_id = ?", "#{self.id}").empty?)
    return false
    else
    return true
    end
  end

  def followers
    Follow.where("artist_id = ?", "#{self.id}").count
  end

  def youtube?
    if(self.youtube == "")
    false
    else
    true
    end
  end

  def soundcloud?
    if(self.soundcloud == "")
    false
    else
    true
    end
  end

  def itunes?
    if(self.itunes == "")
    false
    else
    true
    end
  end

  def label?
    if(self.label_name.nil? and self.label_id.nil?)
    return false
    else
    return true
    end
  end

  def twitter?
    if(self.twitter == "")
    false
    else
    true
    end
  end

  def website?
    if(self.website == "")
    false
    else
    true
    end
  end
end
