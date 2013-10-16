class Suggest < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  validates :user_id, :presence => true
  validates :artist_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :artist_id}

  before_save :default_values
  before_create :check_not_following

  scope :relevant, where(ignore: false)

  def default_values
    # Don't ignore new suggestions
    self.ignore ||= false
    true
  end

  def check_not_following
    if Follow.where(:user_id => user_id, :artist_id => artist_id).count > 0
      return false
    end
  end

  def self.search(user_id, artist_id)
    self.relevant.find(:all, :conditions => ["user_id = '#{user_id}' AND artist_id = '#{artist_id}'"])
  end

  #TODO: It would seem when moving databases around, somewhere along the line, a lot of the suggested artists for users were already being followed by the user. This method quickly removed any rouge suggests.
  def self.remove_redundant_suggests
    User.all.each do |user|
      @follows = Follow.where(:user_id => user.id).all
      @follows.each do |follow|
        Suggest.where(:user_id => follow.user_id, :artist_id => follow.artist_id).destroy_all
      end
    end
  end

end
